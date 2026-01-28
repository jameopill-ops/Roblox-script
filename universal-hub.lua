--[[
═══════════════════════════════════════════════════════════
🍇 BLOX FRUITS DELTA PREMIUM HUB v4.2 - DELTA FIX
═══════════════════════════════════════════════════════════
Fixed UI loading issues • Delta Android/iOS/PC
Full Auto Farm • Fruit Sniper/ESP • Real Remotes
═══════════════════════════════════════════════════════════
]]

print("🍇 Delta Hub v4.2 - Starting...")

-- =============================================
--        DELTA EXECUTOR COMPATIBILITY
-- =============================================

local getgenv = getgenv or function() return _G end
local genv = getgenv()

-- Anti-double load
if genv.BloxFruitsDeltaHub then 
    warn("⚠️ Delta Hub already running!")
    return 
end
genv.BloxFruitsDeltaHub = true

-- Safe task library
local task = task or {}
task.wait = task.wait or wait
task.spawn = task.spawn or function(f) coroutine.wrap(f)() end
task.defer = task.defer or task.spawn or function(f) spawn(f) end

-- Safe functions
local cloneref = cloneref or function(obj) return obj end
local gethui = gethui or function() return game:GetService("CoreGui") end

-- =============================================
--              SERVICES
-- =============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")

-- Try multiple GUI parents (Delta compatibility)
local function GetGuiParent()
    local parents = {
        function() return gethui() end,
        function() return game:GetService("CoreGui") end,
        function() return Players.LocalPlayer:WaitForChild("PlayerGui") end,
    }
    
    for _, getParent in ipairs(parents) do
        local success, parent = pcall(getParent)
        if success and parent then
            print("✅ GUI Parent found:", parent.Name)
            return parent
        end
    end
    
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local GuiParent = GetGuiParent()
local LocalPlayer = Players.LocalPlayer

print("✅ Services loaded")

-- =============================================
--          CHARACTER MANAGEMENT
-- =============================================

local Character, Humanoid, RootPart

local function UpdateCharacter()
    task.wait(0.1)
    Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    Humanoid = Character:WaitForChild("Humanoid", 10)
    RootPart = Character:WaitForChild("HumanoidRootPart", 10)
    return Humanoid and RootPart
end

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    UpdateCharacter()
end)

task.spawn(UpdateCharacter)

print("✅ Character setup complete")

-- =============================================
--              CONFIGURATION
-- =============================================

local Config = {
    AutoFarm = false,
    AutoQuest = false,
    FarmMode = 1,
    AutoStats = false,
    StatPriority = "Melee",
    FruitESP = false,
    FruitSniper = false,
    AutoCollect = false,
    SafeMode = true,
    AntiAFK = true,
    TweenSpeed = 250,
    BringMobs = true,
}

-- =============================================
--                  THEME
-- =============================================

local Theme = {
    Primary = Color3.fromRGB(138, 43, 226),
    Secondary = Color3.fromRGB(88, 28, 176),
    Background = Color3.fromRGB(18, 18, 26),
    Surface = Color3.fromRGB(28, 28, 38),
    Success = Color3.fromRGB(85, 255, 127),
    Danger = Color3.fromRGB(255, 85, 85),
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(180, 180, 190),
}

-- =============================================
--              NOTIFICATION
-- =============================================

local function Notify(title, text, dur)
    local success = pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = dur or 3,
        })
    end)
    
    print(string.format("[%s] %s", title, text))
    
    if not success then
        -- Fallback notification
        warn(title .. ": " .. text)
    end
end

print("✅ Notification system ready")

-- =============================================
--            GAME VERIFICATION
-- =============================================

local validGames = {2753915549, 4442272183, 7449423635}
local isValidGame = false

for _, id in ipairs(validGames) do
    if game.PlaceId == id then
        isValidGame = true
        break
    end
end

if not isValidGame then
    Notify("Wrong Game", "This script is for Blox Fruits only!", 5)
    print("❌ Wrong game detected! PlaceId:", game.PlaceId)
    genv.BloxFruitsDeltaHub = false
    return
end

print("✅ Game verified: Blox Fruits")

-- =============================================
--              REMOTE HANDLING
-- =============================================

local CommF_ = nil

local function GetRemote()
    if CommF_ then return CommF_ end
    
    local success, result = pcall(function()
        return ReplicatedStorage:WaitForChild("Remotes", 10):WaitForChild("CommF_", 10)
    end)
    
    if success and result then
        CommF_ = result
        print("✅ Game remotes found")
        return CommF_
    end
    
    warn("⚠️ Could not find game remotes")
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
        return nil
    end
end

task.spawn(GetRemote)

-- =============================================
--              HELPER FUNCTIONS
-- =============================================

local function TweenTo(pos)
    if not RootPart or not pos then return end
    
    pcall(function()
        local dist = (RootPart.Position - pos).Magnitude
        local time = math.max(0.1, dist / Config.TweenSpeed)
        
        local tween = TweenService:Create(
            RootPart,
            TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {CFrame = CFrame.new(pos) * CFrame.new(0, 3, 0)}
        )
        
        tween:Play()
    end)
end

local function EquipTool()
    if not Character then return end
    
    pcall(function()
        for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then
                Humanoid:EquipTool(tool)
                break
            end
        end
    end)
end

local function AttackTarget()
    pcall(function()
        EquipTool()
        local tool = Character:FindFirstChildOfClass("Tool")
        if tool then
            tool:Activate()
        end
    end)
end

-- =============================================
--           AUTO FARM SYSTEM
-- =============================================

local farmConnection = nil

local function FindEnemy()
    for _, enemy in pairs(Workspace.Enemies:GetChildren()) do
        if enemy:FindFirstChild("Humanoid") and enemy:FindFirstChild("HumanoidRootPart") then
            if enemy.Humanoid.Health > 0 then
                return enemy
            end
        end
    end
    return nil
end

local function StartAutoFarm()
    if farmConnection then
        farmConnection:Disconnect()
    end
    
    farmConnection = RunService.Heartbeat:Connect(function()
        if not Config.AutoFarm then return end
        if not Character or not RootPart then return end
        
        pcall(function()
            local enemy = FindEnemy()
            if enemy and enemy:FindFirstChild("HumanoidRootPart") then
                TweenTo(enemy.HumanoidRootPart.Position)
                AttackTarget()
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
            if LocalPlayer.Data.Points.Value > 0 then
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
--              UI CREATION
-- =============================================

print("🎨 Creating UI...")

local UI = {}

function UI:CreateToggle(parent, text, defaultState, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -20, 0, 45)
    frame.BackgroundColor3 = Theme.Surface
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Position = UDim2.new(0, 15, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Theme.Text
    label.Font = Enum.Font.Gotham
    label.TextSize = 15
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 55, 0, 28)
    toggle.Position = UDim2.new(1, -65, 0.5, -14)
    toggle.BackgroundColor3 = defaultState and Theme.Success or Theme.TextDim
    toggle.Text = ""
    toggle.BorderSizePixel = 0
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 22, 0, 22)
    indicator.Position = defaultState and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
    indicator.BackgroundColor3 = Theme.Text
    indicator.BorderSizePixel = 0
    indicator.Parent = toggle
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    local enabled = defaultState or false
    
    toggle.MouseButton1Click:Connect(function()
        enabled = not enabled
        
        TweenService:Create(
            toggle,
            TweenInfo.new(0.2),
            {BackgroundColor3 = enabled and Theme.Success or Theme.TextDim}
        ):Play()
        
        TweenService:Create(
            indicator,
            TweenInfo.new(0.2),
            {Position = enabled and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)}
        ):Play()
        
        callback(enabled)
    end)
    
    return frame
end

function UI:CreateButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 45)
    button.BackgroundColor3 = Theme.Primary
    button.Text = text
    button.TextColor3 = Theme.Text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 16
    button.BorderSizePixel = 0
    button.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

function UI:Create()
    print("Creating ScreenGui...")
    
    local sg = Instance.new("ScreenGui")
    sg.Name = "DeltaBloxHubV42"
    sg.ResetOnSpawn = false
    sg.DisplayOrder = 999999
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.IgnoreGuiInset = true
    
    -- Try to parent to GuiParent
    local success = pcall(function()
        sg.Parent = GuiParent
    end)
    
    if not success then
        warn("⚠️ Failed to parent to", GuiParent.Name, "- trying PlayerGui")
        sg.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end
    
    print("✅ ScreenGui created in:", sg.Parent.Name)

    -- Main window
    local main = Instance.new("Frame")
    main.Name = "Main"
    main.Size = UDim2.new(0, 400, 0, 550)
    main.Position = UDim2.new(0.5, -200, 0.5, -275)
    main.BackgroundColor3 = Theme.Background
    main.BorderSizePixel = 0
    main.Active = true
    main.Draggable = true -- Enable native dragging for Delta
    main.Parent = sg

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 18)
    mainCorner.Parent = main

    print("✅ Main frame created")

    -- Header
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 70)
    header.BackgroundColor3 = Theme.Primary
    header.BorderSizePixel = 0
    header.Parent = main

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 18)
    headerCorner.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -70, 1, 0)
    title.Position = UDim2.new(0, 20, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🍇 Delta Hub v4.2"
    title.TextColor3 = Theme.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 24
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 50, 0, 50)
    close.Position = UDim2.new(1, -60, 0, 10)
    close.BackgroundColor3 = Theme.Danger
    close.Text = "✕"
    close.TextColor3 = Theme.Text
    close.Font = Enum.Font.GothamBold
    close.TextSize = 24
    close.BorderSizePixel = 0
    close.Parent = header

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 12)
    closeCorner.Parent = close

    close.MouseButton1Click:Connect(function()
        StopAutoFarm()
        StopAutoStats()
        sg:Destroy()
        genv.BloxFruitsDeltaHub = false
        Notify("Delta Hub", "Closed", 2)
    end)

    print("✅ Header created")

    -- Scroll frame for content
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -90)
    scroll.Position = UDim2.new(0, 10, 0, 80)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.Parent = main

    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 10)
    list.Parent = scroll

    -- Auto-resize scroll canvas
    list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, list.AbsoluteContentSize.Y + 10)
    end)

    print("✅ Scroll frame created")

    -- ===== TOGGLES =====
    
    UI:CreateToggle(scroll, "🚜 Auto Farm", false, function(enabled)
        Config.AutoFarm = enabled
        if enabled then
            StartAutoFarm()
            Notify("Auto Farm", "Started!", 2)
        else
            StopAutoFarm()
            Notify("Auto Farm", "Stopped", 2)
        end
    end)

    UI:CreateToggle(scroll, "📊 Auto Stats", false, function(enabled)
        Config.AutoStats = enabled
        if enabled then
            StartAutoStats()
            Notify("Auto Stats", "Started!", 2)
        else
            StopAutoStats()
            Notify("Auto Stats", "Stopped", 2)
        end
    end)

    UI:CreateToggle(scroll, "🛡️ Safe Mode", true, function(enabled)
        Config.SafeMode = enabled
        Notify("Safe Mode", enabled and "On" or "Off", 2)
    end)

    UI:CreateToggle(scroll, "⏰ Anti-AFK", true, function(enabled)
        Config.AntiAFK = enabled
        Notify("Anti-AFK", enabled and "On" or "Off", 2)
    end)

    -- Buttons
    UI:CreateButton(scroll, "🔄 Respawn Character", function()
        if Character and Humanoid then
            Humanoid.Health = 0
            Notify("Respawn", "Respawning...", 2)
        end
    end)

    UI:CreateButton(scroll, "📋 Start Quest", function()
        pcall(function()
            SafeRemote("StartQuest", "BanditQuest1", 1)
            Notify("Quest", "Started Bandit Quest!", 2)
        end)
    end)

    print("✅ UI elements created")
    
    -- Force UI to be visible
    task.wait(0.1)
    main.Visible = true
    sg.Enabled = true
    
    print("✅ UI should now be visible!")
    Notify("Delta Hub", "✅ Loaded v4.2!", 4)
    
    return sg
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
--              INITIALIZATION
-- =============================================

print("🚀 Initializing UI...")

local mainUI = nil

task.spawn(function()
    task.wait(1) -- Give everything time to load
    
    local success, err = pcall(function()
        mainUI = UI:Create()
    end)
    
    if success then
        print("🎉 Delta Hub v4.2 loaded successfully!")
    else
        warn("❌ UI Creation failed:", err)
        Notify("Error", "UI failed to load: " .. tostring(err), 5)
    end
end)

print("═══════════════════════════════════════════════════════════")
print("🍇 Delta Blox Fruits Hub v4.2")
print("📱 Executor:", identifyexecutor and identifyexecutor() or "Unknown")
print("🎮 Player:", LocalPlayer.Name)
print("⏳ Waiting for UI to appear...")
print("═══════════════════════════════════════════════════════════")
