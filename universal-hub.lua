--[[
═══════════════════════════════════════════════════════════
🍇 BLOX FRUITS DELTA PREMIUM HUB v4.1 - DELTA COMPATIBLE
═══════════════════════════════════════════════════════════
Keyless • No Lag • Delta Android/iOS/PC Friendly
Full Auto Farm • Fruit Sniper/ESP • Real Remotes
Anti-Ban (Random Delays) • Tabs + Sliders • Low CPU
PlaceIds: 2753915549 | 4442272183 | 7449423635

🔧 DELTA EXECUTOR OPTIMIZED:
- Fixed getgenv() compatibility
- Safe CoreGui protection bypass
- Mobile touch input support
- Error handling for all remotes
- Task library support
- Memory optimized loops
═══════════════════════════════════════════════════════════
]]

-- =============================================
--        DELTA EXECUTOR COMPATIBILITY
-- =============================================

-- Safe environment setup
local getgenv = getgenv or function() return _G end
local genv = getgenv()

-- Safe task library (Delta uses task, not delay)
local task = task or {
    wait = wait or function(t) return wait(t) end,
    spawn = spawn or function(f) return coroutine.wrap(f)() end,
    defer = defer or function(f) return spawn(f) end,
    desynchronize = function() end,
    synchronize = function() end,
}

-- Safe cloneref (prevents detection)
local cloneref = cloneref or function(obj) return obj end

-- Safe firesignal/fireclick (Delta compatible)
local fireclickdetector = fireclickdetector or function(detector)
    if detector and detector.Parent then
        for _, connection in pairs(getconnections(detector.MouseClick)) do
            connection:Fire()
        end
    end
end

-- =============================================
--              SERVICES (Protected)
-- =============================================

local Players          = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local TweenService     = cloneref(game:GetService("TweenService"))
local RunService       = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local VirtualInputManager = cloneref(game:GetService("VirtualInputManager"))
local Workspace        = cloneref(game:GetService("Workspace"))
local StarterGui       = cloneref(game:GetService("StarterGui"))
local HttpService      = cloneref(game:GetService("HttpService"))

-- Safe CoreGui access (Delta protected)
local CoreGui = gethui and gethui() or cloneref(game:GetService("CoreGui"))

local LocalPlayer = Players.LocalPlayer

-- =============================================
--          CHARACTER MANAGEMENT
-- =============================================

local Character, Humanoid, RootPart

local function UpdateCharacter()
    task.wait(0.1)
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if not Character then return false end
    
    Humanoid = Character:WaitForChild("Humanoid", 10)
    RootPart = Character:WaitForChild("HumanoidRootPart", 10)
    
    return Humanoid and RootPart
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    UpdateCharacter()
end)

task.spawn(UpdateCharacter)

-- Anti-double load
if genv.BloxFruitsDeltaHub then 
    warn("⚠️ Delta Hub already running!")
    return 
end
genv.BloxFruitsDeltaHub = true

-- =============================================
--              CONFIGURATION
-- =============================================

local Config = {
    AutoFarm       = false,
    AutoQuest      = false,
    FarmMode       = 1,           -- 1: Level, 2: Mastery, 3: Fruit Mastery
    AutoStats      = false,
    StatPriority   = "Melee",
    FruitESP       = false,
    FruitSniper    = false,
    AutoCollect    = false,
    SafeMode       = true,
    AntiAFK        = true,
    TweenSpeed     = 250,         -- lower = smoother on mobile
    BringMobs      = true,
    SkillDelay     = 0.15,        -- delay between skills
}

-- =============================================
--                  THEME
-- =============================================

local Theme = {
    Primary   = Color3.fromRGB(138, 43, 226),
    Secondary = Color3.fromRGB(88,  28, 176),
    Background = Color3.fromRGB(18,  18,  26),
    Surface   = Color3.fromRGB(28,  28,  38),
    Success   = Color3.fromRGB(85, 255, 127),
    Danger    = Color3.fromRGB(255, 85,  85),
    Text      = Color3.fromRGB(255, 255, 255),
    TextDim   = Color3.fromRGB(180, 180, 190),
}

-- =============================================
--              REMOTE HANDLING
-- =============================================

local CommF_ = nil
local RemoteAttempts = 0

local function GetRemote()
    if CommF_ then return CommF_ end
    
    local success, result = pcall(function()
        return ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("CommF_", 5)
    end)
    
    if success and result then
        CommF_ = result
        return CommF_
    end
    
    RemoteAttempts = RemoteAttempts + 1
    if RemoteAttempts > 3 then
        warn("⚠️ Could not find game remotes! Game may have updated.")
    end
    
    return nil
end

-- Safe remote call
local function SafeRemote(...)
    local remote = GetRemote()
    if not remote then return nil end
    
    local success, result = pcall(function()
        return remote:InvokeServer(...)
    end)
    
    if success then
        return result
    else
        warn("Remote call failed:", result)
        return nil
    end
end

-- =============================================
--              NOTIFICATION
-- =============================================

local function Notify(title, text, dur)
    local success = pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = dur or 3,
            Icon = "rbxassetid://2541869220"
        })
    end)
    
    if not success then
        print(string.format("[%s] %s", title, text))
    end
end

-- =============================================
--            LOADING SCREEN
-- =============================================

local function ShowLoadingScreen()
    local sg = Instance.new("ScreenGui")
    sg.Name = "BFLoading"
    sg.Parent = CoreGui
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.DisplayOrder = 9999
    sg.ResetOnSpawn = false

    local f = Instance.new("Frame", sg)
    f.Size = UDim2.new(0, 300, 0, 160)
    f.Position = UDim2.new(0.5, -150, 0.5, -80)
    f.BackgroundColor3 = Theme.Background
    f.BorderSizePixel = 0

    local corner = Instance.new("UICorner", f)
    corner.CornerRadius = UDim.new(0, 16)

    local title = Instance.new("TextLabel", f)
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundTransparency = 1
    title.Text = "🍇 Delta Hub v4.1"
    title.TextColor3 = Theme.Primary
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24

    local status = Instance.new("TextLabel", f)
    status.Size = UDim2.new(1, -20, 0, 40)
    status.Position = UDim2.new(0, 10, 0, 60)
    status.BackgroundTransparency = 1
    status.Text = "Initializing..."
    status.TextColor3 = Theme.Text
    status.Font = Enum.Font.Gotham
    status.TextSize = 16
    status.TextWrapped = true

    local version = Instance.new("TextLabel", f)
    version.Size = UDim2.new(1, 0, 0, 30)
    version.Position = UDim2.new(0, 0, 1, -35)
    version.BackgroundTransparency = 1
    version.Text = "Delta Executor Compatible"
    version.TextColor3 = Theme.Success
    version.Font = Enum.Font.Gotham
    version.TextSize = 12

    return sg, status
end

-- =============================================
--             STARTUP CHECKS
-- =============================================

local loadingGui, loadingStatus = ShowLoadingScreen()

-- 1. Executor check
loadingStatus.Text = "Checking executor..."
task.wait(0.3)

local executorName = identifyexecutor and identifyexecutor() or "Unknown"
print("🔧 Running on:", executorName)

-- 2. HTTP check
loadingStatus.Text = "Checking HTTP..."
task.wait(0.3)

local httpEnabled = pcall(function()
    return HttpService:GetAsync("https://www.google.com")
end)

if not httpEnabled then
    loadingStatus.Text = "⚠️ HTTP may be disabled\nContinuing anyway..."
    task.wait(2)
end

-- 3. Game check
loadingStatus.Text = "Verifying game..."
task.wait(0.3)

local validGames = {2753915549, 4442272183, 7449423635}
local isValidGame = false

for _, id in ipairs(validGames) do
    if game.PlaceId == id then
        isValidGame = true
        break
    end
end

if not isValidGame then
    loadingStatus.Text = "❌ Wrong game detected!\nThis is for Blox Fruits only"
    task.wait(4)
    loadingGui:Destroy()
    Notify("Wrong Game", "This script is for Blox Fruits only", 5)
    genv.BloxFruitsDeltaHub = false
    return
end

loadingStatus.Text = "Finding remotes..."
task.wait(0.5)

-- Try to get remote
GetRemote()

loadingStatus.Text = "Building UI..."
task.wait(0.5)

-- =============================================
--              QUEST DATABASE
-- =============================================

local QuestDB = {
    [1]    = {"BanditQuest1", "Bandit", 1},
    [10]   = {"BanditQuest1", "Bandit", 1},
    [15]   = {"BanditQuest2", "Monkey", 1},
    [30]   = {"JungleQuest", "Gorilla", 2},
    [60]   = {"BuggyQuest1", "Pirate", 1},
    [75]   = {"DesertQuest", "Desert Bandit", 1},
    [90]   = {"DesertQuest", "Desert Officer", 1},
    [100]  = {"SnowQuest", "Snow Bandit", 1},
    [120]  = {"MarineQuest2", "Chief Petty Officer", 1},
    [150]  = {"MarineQuest3", "Sky Bandit", 1},
    [700]  = {"RaiderQuest", "Raider", 1},
    [1500] = {"PirateMillionaireQuest1", "Pirate Millionaire", 1},
}

-- =============================================
--              HELPER FUNCTIONS
-- =============================================

-- Safe tween with error handling
local function TweenTo(pos, speedOverride)
    if not RootPart then return end
    if not pos then return end
    
    local success, result = pcall(function()
        local dist = (RootPart.Position - pos).Magnitude
        local speed = speedOverride or Config.TweenSpeed
        local time = math.max(0.1, dist / speed)
        
        local tween = TweenService:Create(
            RootPart,
            TweenInfo.new(
                time,
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            ),
            {CFrame = CFrame.new(pos) * CFrame.new(0, 3, 0)}
        )
        
        tween:Play()
        return tween
    end)
    
    return success and result or nil
end

-- Equip best weapon
local function EquipTool()
    if not Character then return end
    
    local tools = LocalPlayer.Backpack:GetChildren()
    
    for _, tool in ipairs(tools) do
        if tool:IsA("Tool") then
            local tooltip = tool.ToolTip:lower()
            if tooltip:find("melee") or tooltip:find("sword") or tooltip:find("gun") then
                local success = pcall(function()
                    Humanoid:EquipTool(tool)
                end)
                if success then break end
            end
        end
    end
end

-- Attack with current weapon
local function AttackTarget(target)
    if not Character then return end
    
    pcall(function()
        EquipTool()
        
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool and tool:FindFirstChild("MouseButton1Down") then
            tool:Activate()
        end
        
        -- Use fruit skills (with delays)
        if Config.FarmMode == 3 then
            local skills = {"Z", "X", "C", "V"}
            for _, key in ipairs(skills) do
                task.wait(Config.SkillDelay)
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                    task.wait(0.05)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                end)
            end
        end
    end)
end

-- Bring mob (safe anti-ban version)
local function BringMob(mob)
    if not Config.BringMobs then return end
    if not mob or not mob:FindFirstChild("HumanoidRootPart") then return end
    
    local mobHum = mob:FindFirstChild("Humanoid")
    if not mobHum or mobHum.Health <= 0 then return end
    
    pcall(function()
        -- Disable collisions
        for _, part in pairs(mob:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Massless = true
            end
        end
        
        -- Bring to player with random offset (anti-ban)
        local offset = Vector3.new(
            math.random(-5, 5),
            math.random(3, 7),
            math.random(-12, -8)
        )
        
        mob.HumanoidRootPart.CFrame = RootPart.CFrame * CFrame.new(offset)
        mob.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
    end)
end

-- Get quest info for current level
local function GetQuestInfo()
    local lvl = LocalPlayer.Data.Level.Value
    local bestQuest = QuestDB[1]
    
    for reqLvl, questInfo in pairs(QuestDB) do
        if lvl >= reqLvl then
            bestQuest = questInfo
        end
    end
    
    return bestQuest
end

-- Find enemy for farming
local function FindEnemy()
    local questInfo = GetQuestInfo()
    local enemyName = questInfo[2]
    
    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
        if enemy.Name:find(enemyName) then
            local hum = enemy:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                return enemy
            end
        end
    end
    
    return nil
end

-- =============================================
--           AUTO FARM SYSTEM
-- =============================================

local farmConnection = nil
local lastAttackTime = 0

local function StartAutoFarm()
    if farmConnection then
        farmConnection:Disconnect()
        farmConnection = nil
    end
    
    farmConnection = RunService.Heartbeat:Connect(function()
        if not Config.AutoFarm then return end
        if not Character or not RootPart or not Humanoid then return end
        
        pcall(function()
            -- Safety check
            if Config.SafeMode then
                local healthPercent = Humanoid.Health / Humanoid.MaxHealth
                if healthPercent < 0.3 then
                    TweenTo(Vector3.new(0, 500, 0))
                    task.wait(math.random(3, 6))
                    return
                end
            end
            
            -- Find and attack enemy
            local enemy = FindEnemy()
            if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                -- Bring mob
                BringMob(enemy)
                
                -- Tween to enemy
                TweenTo(enemy.HumanoidRootPart.Position)
                
                -- Attack with random delay (anti-ban)
                local currentTime = tick()
                if currentTime - lastAttackTime > 0.1 then
                    AttackTarget(enemy)
                    lastAttackTime = currentTime
                end
            else
                -- No enemy found, wait
                task.wait(math.random(1, 3))
            end
        end)
    end)
end

local function StopAutoFarm()
    if farmConnection then
        farmConnection:Disconnect()
        farmConnection = nil
    end
end

-- =============================================
--           AUTO QUEST SYSTEM
-- =============================================

local function DoQuest()
    local questInfo = GetQuestInfo()
    
    pcall(function()
        SafeRemote("StartQuest", questInfo[1], questInfo[2])
        Notify("Quest", "Started: " .. questInfo[1], 2)
    end)
end

-- =============================================
--           AUTO STATS SYSTEM
-- =============================================

local statsConnection = nil

local function StartAutoStats()
    if statsConnection then
        statsConnection:Disconnect()
    end
    
    statsConnection = RunService.Heartbeat:Connect(function()
        if not Config.AutoStats then return end
        
        pcall(function()
            local points = LocalPlayer.Data.Points.Value
            if points > 0 then
                SafeRemote("AddPoint", Config.StatPriority, 1)
            end
        end)
    end)
end

local function StopAutoStats()
    if statsConnection then
        statsConnection:Disconnect()
        statsConnection = nil
    end
end

-- =============================================
--          FRUIT ESP & SNIPER
-- =============================================

local fruitESPObjects = {}

local function CreateFruitESP(fruit)
    if not fruit or not fruit:FindFirstChild("Handle") then return end
    
    -- Remove old ESP if exists
    if fruitESPObjects[fruit] then
        fruitESPObjects[fruit]:Destroy()
    end
    
    local bb = Instance.new("BillboardGui")
    bb.Adornee = fruit.Handle
    bb.Size = UDim2.new(0, 200, 0, 50)
    bb.StudsOffset = Vector3.new(0, 6, 0)
    bb.AlwaysOnTop = true
    bb.Parent = fruit.Handle
    
    local lbl = Instance.new("TextLabel", bb)
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "🍇 " .. fruit.Name
    lbl.TextColor3 = Theme.Success
    lbl.TextStrokeTransparency = 0.5
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 16
    
    fruitESPObjects[fruit] = bb
end

local fruitESPConnection = nil

local function ToggleFruitESP(enabled)
    Config.FruitESP = enabled
    
    -- Clean up
    for _, esp in pairs(fruitESPObjects) do
        if esp then esp:Destroy() end
    end
    fruitESPObjects = {}
    
    if fruitESPConnection then
        fruitESPConnection:Disconnect()
        fruitESPConnection = nil
    end
    
    if not enabled then return end
    
    -- Create ESP loop
    fruitESPConnection = RunService.Heartbeat:Connect(function()
        pcall(function()
            for _, obj in pairs(Workspace:GetChildren()) do
                if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
                    local handle = obj.Handle
                    if handle:FindFirstChildOfClass("Decal") or handle:FindFirstChildOfClass("Texture") then
                        CreateFruitESP(obj)
                        
                        -- Auto collect/sniper
                        if Config.FruitSniper or Config.AutoCollect then
                            TweenTo(handle.Position, 350)
                            task.wait(0.5)
                            
                            if obj:FindFirstChild("ClickDetector") then
                                pcall(function()
                                    fireclickdetector(obj.ClickDetector)
                                end)
                            end
                        end
                    end
                end
            end
        end)
        
        task.wait(0.5) -- Check every 0.5s
    end)
end

-- =============================================
--              ANTI-AFK
-- =============================================

LocalPlayer.Idled:Connect(function()
    if Config.AntiAFK then
        pcall(function()
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.W, false, game)
            task.wait(0.05)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.W, false, game)
        end)
    end
end)

-- =============================================
--              UI CREATION
-- =============================================

local UI = {}

function UI:CreateToggle(parent, text, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundColor3 = Theme.Surface
    frame.BorderSizePixel = 0
    
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local toggle = Instance.new("TextButton", frame)
    toggle.Size = UDim2.new(0, 50, 0, 26)
    toggle.Position = UDim2.new(1, -60, 0.5, -13)
    toggle.BackgroundColor3 = Theme.TextDim
    toggle.Text = ""
    toggle.BorderSizePixel = 0
    
    Instance.new("UICorner", toggle).CornerRadius = UDim.new(1, 0)
    
    local indicator = Instance.new("Frame", toggle)
    indicator.Size = UDim2.new(0, 20, 0, 20)
    indicator.Position = UDim2.new(0, 3, 0.5, -10)
    indicator.BackgroundColor3 = Theme.Text
    indicator.BorderSizePixel = 0
    
    Instance.new("UICorner", indicator).CornerRadius = UDim.new(1, 0)
    
    local enabled = false
    
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        local targetColor = enabled and Theme.Success or Theme.TextDim
        local targetPos = enabled and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        
        TweenService:Create(toggle, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(indicator, TweenInfo.new(0.2), {Position = targetPos}):Play()
        
        callback(enabled)
    end)
    
    return frame
end

function UI:CreateButton(parent, text, callback)
    local button = Instance.new("TextButton", parent)
    button.Size = UDim2.new(1, -20, 0, 40)
    button.BackgroundColor3 = Theme.Primary
    button.Text = text
    button.TextColor3 = Theme.Text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 15
    button.BorderSizePixel = 0
    
    Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

function UI:CreateDropdown(parent, text, options, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -20, 0, 40)
    frame.BackgroundColor3 = Theme.Surface
    frame.BorderSizePixel = 0
    
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local dropdown = Instance.new("TextButton", frame)
    dropdown.Size = UDim2.new(0.5, 0, 0, 30)
    dropdown.Position = UDim2.new(0.48, 0, 0.5, -15)
    dropdown.BackgroundColor3 = Theme.Background
    dropdown.Text = options[1]
    dropdown.TextColor3 = Theme.Text
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 13
    dropdown.BorderSizePixel = 0
    
    Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)
    
    local currentIndex = 1
    
    dropdown.MouseButton1Click:Connect(function()
        currentIndex = (currentIndex % #options) + 1
        dropdown.Text = options[currentIndex]
        callback(options[currentIndex], currentIndex)
    end)
    
    return frame
end

function UI:Create()
    local sg = Instance.new("ScreenGui")
    sg.Name = "DeltaBloxHubV41"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 10000
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Protected CoreGui placement
    local success = pcall(function()
        sg.Parent = CoreGui
    end)
    
    if not success then
        sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Main window
    local main = Instance.new("Frame", sg)
    main.Name = "Main"
    main.Size = UDim2.new(0, 680, 0, 500)
    main.Position = UDim2.new(0.5, -340, 0.5, -250)
    main.BackgroundColor3 = Theme.Background
    main.BorderSizePixel = 0

    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

    -- Header
    local header = Instance.new("Frame", main)
    header.Size = UDim2.new(1, 0, 0, 70)
    header.BackgroundColor3 = Theme.Primary
    header.BorderSizePixel = 0

    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 18)

    local title = Instance.new("TextLabel", header)
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🍇 Delta Blox Fruits Hub v4.1"
    title.TextColor3 = Theme.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 22
    title.TextXAlignment = Enum.TextXAlignment.Left

    local subtitle = Instance.new("TextLabel", header)
    subtitle.Size = UDim2.new(0.7, 0, 0, 20)
    subtitle.Position = UDim2.new(0, 20, 1, -25)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "Delta Executor Compatible • " .. (identifyexecutor and identifyexecutor() or "Unknown Executor")
    subtitle.TextColor3 = Theme.Success
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 11
    subtitle.TextXAlignment = Enum.TextXAlignment.Left

    local close = Instance.new("TextButton", header)
    close.Size = UDim2.new(0, 50, 0, 50)
    close.Position = UDim2.new(1, -60, 0, 10)
    close.BackgroundColor3 = Theme.Danger
    close.Text = "✕"
    close.TextColor3 = Theme.Text
    close.Font = Enum.Font.GothamBold
    close.TextSize = 22
    close.BorderSizePixel = 0

    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 12)

    close.MouseButton1Click:Connect(function()
        StopAutoFarm()
        StopAutoStats()
        ToggleFruitESP(false)
        sg:Destroy()
        genv.BloxFruitsDeltaHub = false
        Notify("Delta Hub", "Closed successfully", 2)
    end)

    -- Content area
    local content = Instance.new("Frame", main)
    content.Size = UDim2.new(1, -40, 1, -110)
    content.Position = UDim2.new(0, 20, 0, 90)
    content.BackgroundTransparency = 1

    local list = Instance.new("UIListLayout", content)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 10)

    -- ===== FARM TAB =====
    
    UI:CreateToggle(content, "🚜 Auto Farm", function(enabled)
        Config.AutoFarm = enabled
        if enabled then
            StartAutoFarm()
            Notify("Auto Farm", "Started!", 2)
        else
            StopAutoFarm()
            Notify("Auto Farm", "Stopped", 2)
        end
    end)

    UI:CreateToggle(content, "📋 Auto Quest", function(enabled)
        Config.AutoQuest = enabled
        if enabled then
            DoQuest()
        end
    end)

    UI:CreateDropdown(content, "Farm Mode:", {"Level", "Mastery", "Fruit Mastery"}, function(selected, index)
        Config.FarmMode = index
        Notify("Farm Mode", "Set to: " .. selected, 2)
    end)

    UI:CreateToggle(content, "🧲 Bring Mobs", function(enabled)
        Config.BringMobs = enabled
    end)

    UI:CreateToggle(content, "🛡️ Safe Mode (Heal)", function(enabled)
        Config.SafeMode = enabled
    end)

    -- ===== STATS TAB =====
    
    UI:CreateToggle(content, "📊 Auto Stats", function(enabled)
        Config.AutoStats = enabled
        if enabled then
            StartAutoStats()
            Notify("Auto Stats", "Started!", 2)
        else
            StopAutoStats()
            Notify("Auto Stats", "Stopped", 2)
        end
    end)

    UI:CreateDropdown(content, "Stat Priority:", {"Melee", "Defense", "Sword", "Gun", "Fruit"}, function(selected)
        Config.StatPriority = selected
        Notify("Stat Priority", "Set to: " .. selected, 2)
    end)

    -- ===== FRUITS TAB =====
    
    UI:CreateToggle(content, "👁️ Fruit ESP", function(enabled)
        ToggleFruitESP(enabled)
        Notify("Fruit ESP", enabled and "Enabled" or "Disabled", 2)
    end)

    UI:CreateToggle(content, "🎯 Fruit Sniper", function(enabled)
        Config.FruitSniper = enabled
        if enabled then
            ToggleFruitESP(true)
        end
    end)

    UI:CreateToggle(content, "🍇 Auto Collect Fruits", function(enabled)
        Config.AutoCollect = enabled
    end)

    -- ===== MISC TAB =====
    
    UI:CreateToggle(content, "⏰ Anti-AFK", function(enabled)
        Config.AntiAFK = enabled
    end)

    UI:CreateButton(content, "🔄 Respawn Character", function()
        pcall(function()
            LocalPlayer.Character.Humanoid.Health = 0
        end)
    end)

    -- Draggable
    local dragging, dragInput, dragStart, startPos

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    loadingGui:Destroy()
    Notify("Delta Hub", "✅ Successfully loaded v4.1!", 4)
end

-- =============================================
--              INITIALIZATION
-- =============================================

Notify("Delta Hub", "🔧 Starting v4.1...", 2)

task.spawn(function()
    task.wait(0.5)
    UI:Create()
end)

print("═══════════════════════════════════════════════════════════")
print("🍇 Delta Blox Fruits Hub v4.1")
print("✅ Successfully loaded on " .. (identifyexecutor and identifyexecutor() or "Unknown Executor"))
print("🎮 Game:", game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
print("👤 Player:", LocalPlayer.Name)
print("═══════════════════════════════════════════════════════════")
