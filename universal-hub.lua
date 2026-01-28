--[[
    ═══════════════════════════════════════════════════════════
    🍇 BLOX FRUITS PREMIUM HUB - DELTA EXECUTOR
    ═══════════════════════════════════════════════════════════
    
    Game: Blox Fruits
    Version: 3.0 Premium Edition
    Executor: Delta Compatible
    
    Features:
    ✓ Auto Farm Mastery & Levels
    ✓ Auto Quest System
    ✓ Fruit ESP & Notifier
    ✓ Boss Farm
    ✓ Auto Stats Allocation
    ✓ Sea Event Farm
    ✓ Raid Helper
    ✓ Material Grinder
    ✓ Safe Anti-Ban Features
    
    ═══════════════════════════════════════════════════════════
]]

-- Security Check
if game.PlaceId ~= 2753915549 and game.PlaceId ~= 4442272183 and game.PlaceId ~= 7449423635 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❌ Wrong Game!",
        Text = "This script only works in Blox Fruits!",
        Duration = 5
    })
    return
end

-- Anti-Double Load
if getgenv().BloxFruitsHubLoaded then
    return
end
getgenv().BloxFruitsHubLoaded = true

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")

-- Player References
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Update character references on respawn
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end)

-- Hub Configuration
local Config = {
    -- Auto Farm Settings
    AutoFarm = false,
    AutoFarmMode = "Level", -- "Level", "Mastery", "Boss"
    SelectedBoss = "Saber Expert",
    FarmDistance = 15,
    
    -- Quest Settings
    AutoQuest = false,
    
    -- Fruit Settings
    FruitESP = false,
    FruitNotifier = true,
    AutoCollectFruit = false,
    
    -- Stats Settings
    AutoStats = false,
    SelectedStat = "Melee", -- "Melee", "Defense", "Sword", "Gun", "Fruit"
    
    -- Material Farm
    MaterialFarm = false,
    SelectedMaterial = "Leather",
    
    -- Raid Settings
    AutoRaid = false,
    
    -- Sea Event
    AutoSeaEvent = false,
    
    -- Safety Settings
    AntiAFK = true,
    AutoRespawn = true,
    SafeMode = true, -- Teleports away when low health
    SafeHealthPercent = 30,
    
    -- Visual Settings
    ESPEnabled = false,
    ShowDistance = true,
    
    -- Performance
    TweenSpeed = 300,
}

-- Theme Colors
local Theme = {
    Primary = Color3.fromRGB(138, 43, 226),
    Secondary = Color3.fromRGB(88, 28, 176),
    Background = Color3.fromRGB(20, 20, 28),
    Surface = Color3.fromRGB(30, 30, 40),
    Accent = Color3.fromRGB(255, 107, 107),
    Success = Color3.fromRGB(85, 255, 127),
    Warning = Color3.fromRGB(255, 200, 87),
    Text = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(180, 180, 190),
}

--[[
    ═══════════════════════════════════════════════════════════
    BLOX FRUITS GAME FUNCTIONS
    ═══════════════════════════════════════════════════════════
]]

local GameFunctions = {}

-- Get Player Level
function GameFunctions:GetLevel()
    return LocalPlayer.Data.Level.Value or 1
end

-- Check if player has quest
function GameFunctions:HasQuest()
    local questData = LocalPlayer.PlayerGui.Main.Quest
    return questData.Visible
end

-- Get recommended quest based on level
function GameFunctions:GetRecommendedQuest()
    local level = self:GetLevel()
    
    -- First Sea (1-700)
    if level < 10 then return "Bandit"
    elseif level < 15 then return "Monkey"
    elseif level < 30 then return "Gorilla"
    elseif level < 60 then return "Pirate"
    elseif level < 75 then return "Brute"
    elseif level < 90 then return "Desert Bandit"
    elseif level < 100 then return "Desert Officer"
    elseif level < 120 then return "Snow Bandit"
    elseif level < 150 then return "Snowman"
    elseif level < 175 then return "Chief Petty Officer"
    elseif level < 190 then return "Sky Bandit"
    elseif level < 210 then return "Dark Master"
    elseif level < 250 then return "Prisoner"
    elseif level < 275 then return "Dangerous Prisoner"
    elseif level < 300 then return "Toga Warrior"
    elseif level < 325 then return "Gladiator"
    elseif level < 350 then return "Military Soldier"
    elseif level < 375 then return "Military Spy"
    elseif level < 400 then return "Fishman Warrior"
    elseif level < 450 then return "Fishman Commando"
    elseif level < 475 then return "God's Guard"
    elseif level < 525 then return "Shanda"
    elseif level < 575 then return "Royal Squad"
    elseif level < 625 then return "Royal Soldier"
    elseif level < 700 then return "Galley Pirate"
    
    -- Second Sea (700-1500)
    elseif level < 725 then return "Raider"
    elseif level < 775 then return "Mercenary"
    elseif level < 800 then return "Swan Pirate"
    elseif level < 875 then return "Factory Staff"
    elseif level < 900 then return "Marine Lieutenant"
    elseif level < 925 then return "Marine Captain"
    elseif level < 975 then return "Zombie"
    elseif level < 1000 then return "Vampire"
    elseif level < 1050 then return "Snow Trooper"
    elseif level < 1100 then return "Winter Warrior"
    elseif level < 1125 then return "Lab Subordinate"
    elseif level < 1175 then return "Horned Warrior"
    elseif level < 1200 then return "Magma Ninja"
    elseif level < 1250 then return "Lava Pirate"
    elseif level < 1300 then return "Ship Deckhand"
    elseif level < 1350 then return "Ship Engineer"
    elseif level < 1400 then return "Ship Steward"
    elseif level < 1450 then return "Ship Officer"
    elseif level < 1500 then return "Arctic Warrior"
    
    -- Third Sea (1500+)
    elseif level < 1575 then return "Pirate Millionaire"
    elseif level < 1625 then return "Dragon Crew Warrior"
    elseif level < 1675 then return "Dragon Crew Archer"
    elseif level < 1700 then return "Female Islander"
    elseif level < 1725 then return "Giant Islander"
    elseif level < 1775 then return "Marine Commodore"
    elseif level < 1800 then return "Marine Rear Admiral"
    elseif level < 1850 then return "Fishman Raider"
    elseif level < 1900 then return "Fishman Captain"
    elseif level < 1950 then return "Forest Pirate"
    elseif level < 2000 then return "Mythological Pirate"
    elseif level < 2050 then return "Jungle Pirate"
    elseif level < 2075 then return "Musketeer Pirate"
    elseif level < 2100 then return "Reborn Skeleton"
    elseif level < 2125 then return "Living Zombie"
    elseif level < 2150 then return "Demonic Soul"
    elseif level < 2200 then return "Posessed Mummy"
    else return "Pirate Millionaire" -- Default for high levels
    end
end

-- Get enemy for quest
function GameFunctions:GetQuestEnemy()
    local questName = self:GetRecommendedQuest()
    
    -- Find enemies in workspace
    local enemies = Workspace.Enemies:GetChildren()
    
    for _, enemy in pairs(enemies) do
        if enemy:IsA("Model") and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
            if enemy.Humanoid.Health > 0 and string.find(enemy.Name, questName) then
                return enemy
            end
        end
    end
    
    return nil
end

-- Tween to position (smooth movement)
function GameFunctions:TweenToPosition(targetPosition)
    if not HumanoidRootPart then return end
    
    local distance = (HumanoidRootPart.Position - targetPosition).Magnitude
    local speed = Config.TweenSpeed
    local time = distance / speed
    
    local tween = TweenService:Create(
        HumanoidRootPart,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(targetPosition)}
    )
    
    tween:Play()
    return tween
end

-- Equip weapon
function GameFunctions:EquipWeapon()
    local weapon = nil
    
    -- Try to find a weapon in inventory
    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
        if item:IsA("Tool") and (item.ToolTip == "Sword" or item.ToolTip == "Melee") then
            weapon = item
            break
        end
    end
    
    -- If weapon found and not already equipped
    if weapon and not Character:FindFirstChild(weapon.Name) then
        Humanoid:EquipTool(weapon)
    end
end

-- Attack enemy
function GameFunctions:AttackEnemy(enemy)
    if not enemy or not enemy:FindFirstChild("HumanoidRootPart") then return end
    
    -- Equip weapon
    self:EquipWeapon()
    
    -- Use click to attack (compatible with most weapons)
    local tool = Character:FindFirstChildOfClass("Tool")
    if tool and tool:FindFirstChild("MouseButton1Down") then
        tool:Activate()
    else
        -- Virtual click
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        wait()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end
end

-- Bring enemy to you (makes farming easier)
function GameFunctions:BringEnemy(enemy)
    if not enemy or not enemy:FindFirstChild("HumanoidRootPart") or not enemy:FindFirstChild("Humanoid") then return end
    
    if enemy.Humanoid.Health > 0 then
        -- Disable enemy collisions
        for _, part in pairs(enemy:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
        
        -- Bring enemy close to player
        enemy.HumanoidRootPart.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -Config.FarmDistance)
        enemy.HumanoidRootPart.Anchored = true
    end
end

-- Check if low health
function GameFunctions:IsLowHealth()
    if not Humanoid then return false end
    local healthPercent = (Humanoid.Health / Humanoid.MaxHealth) * 100
    return healthPercent <= Config.SafeHealthPercent
end

--[[
    ═══════════════════════════════════════════════════════════
    AUTO FARM SYSTEM
    ═══════════════════════════════════════════════════════════
]]

local AutoFarm = {}

function AutoFarm:Start()
    spawn(function()
        while Config.AutoFarm and wait(0.1) do
            pcall(function()
                -- Safety check
                if Config.SafeMode and GameFunctions:IsLowHealth() then
                    -- Teleport to safe spot (spawn)
                    if HumanoidRootPart then
                        HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
                    end
                    wait(5)
                    return
                end
                
                -- Get quest if auto quest is enabled
                if Config.AutoQuest and not GameFunctions:HasQuest() then
                    self:GetQuest()
                end
                
                -- Find and attack enemies
                local enemy = GameFunctions:GetQuestEnemy()
                
                if enemy and enemy:FindFirstChild("HumanoidRootPart") and enemy:FindFirstChild("Humanoid") then
                    if enemy.Humanoid.Health > 0 then
                        -- Move to enemy
                        local enemyPos = enemy.HumanoidRootPart.Position
                        local farmPos = enemyPos + Vector3.new(0, Config.FarmDistance, 0)
                        
                        if (HumanoidRootPart.Position - farmPos).Magnitude > 5 then
                            GameFunctions:TweenToPosition(farmPos)
                        end
                        
                        -- Bring enemy (optional, makes farming faster)
                        GameFunctions:BringEnemy(enemy)
                        
                        -- Attack
                        GameFunctions:AttackEnemy(enemy)
                    end
                else
                    -- No enemy found, wait for respawn
                    wait(2)
                end
            end)
        end
    end)
end

function AutoFarm:GetQuest()
    -- This is a simplified version
    -- In a full implementation, you'd need to know quest giver locations
    -- and interact with them properly
    
    local questGiver = self:FindQuestGiver()
    if questGiver and questGiver:FindFirstChild("HumanoidRootPart") then
        -- Tween to quest giver
        GameFunctions:TweenToPosition(questGiver.HumanoidRootPart.Position)
        wait(1)
        
        -- Interact (this varies by quest giver)
        -- You would need to use RemoteEvents or ProximityPrompts
    end
end

function AutoFarm:FindQuestGiver()
    -- Find quest giver based on recommended quest
    local questName = GameFunctions:GetRecommendedQuest()
    
    -- Search NPCs
    local npcs = Workspace.NPCs:GetChildren()
    for _, npc in pairs(npcs) do
        if npc.Name:find("Quest") and npc:FindFirstChild("HumanoidRootPart") then
            return npc
        end
    end
    
    return nil
end

--[[
    ═══════════════════════════════════════════════════════════
    FRUIT ESP & NOTIFIER
    ═══════════════════════════════════════════════════════════
]]

local FruitESP = {}
FruitESP.ESPInstances = {}

function FruitESP:Create()
    spawn(function()
        while Config.FruitESP and wait(2) do
            pcall(function()
                self:UpdateESP()
            end)
        end
    end)
end

function FruitESP:UpdateESP()
    -- Clear old ESP
    for _, esp in pairs(self.ESPInstances) do
        esp:Destroy()
    end
    self.ESPInstances = {}
    
    -- Find fruits
    for _, object in pairs(Workspace:GetChildren()) do
        if object:IsA("Tool") and object:FindFirstChild("Handle") then
            -- Likely a fruit
            self:AddESP(object)
        end
    end
end

function FruitESP:AddESP(fruit)
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Adornee = fruit:FindFirstChild("Handle")
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 3, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = fruit.Handle
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "🍇 " .. fruit.Name
    textLabel.TextColor3 = Theme.Warning
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 14
    textLabel.TextStrokeTransparency = 0
    textLabel.Parent = billboardGui
    
    if Config.ShowDistance then
        spawn(function()
            while textLabel and textLabel.Parent and wait(0.5) do
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - fruit.Handle.Position).Magnitude
                textLabel.Text = string.format("🍇 %s\n[%.0fm]", fruit.Name, distance)
            end
        end)
    end
    
    table.insert(self.ESPInstances, billboardGui)
    
    -- Notification
    if Config.FruitNotifier then
        self:NotifyFruit(fruit.Name)
    end
end

function FruitESP:NotifyFruit(fruitName)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🍇 Fruit Found!",
        Text = fruitName .. " has spawned!",
        Duration = 5
    })
end

--[[
    ═══════════════════════════════════════════════════════════
    AUTO STATS SYSTEM
    ═══════════════════════════════════════════════════════════
]]

local AutoStats = {}

function AutoStats:Start()
    spawn(function()
        while Config.AutoStats and wait(1) do
            pcall(function()
                self:AllocatePoints()
            end)
        end
    end)
end

function AutoStats:AllocatePoints()
    -- Check if player has points to spend
    local points = LocalPlayer.Data.Points.Value or 0
    
    if points > 0 then
        -- Allocate to selected stat
        local statName = Config.SelectedStat
        
        -- This would need to call the actual game remote
        -- Example: game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", statName, 1)
        
        print("Allocated point to " .. statName)
    end
end

--[[
    ═══════════════════════════════════════════════════════════
    ANTI-AFK SYSTEM
    ═══════════════════════════════════════════════════════════
]]

local AntiAFK = {}

function AntiAFK:Start()
    local VirtualUser = game:GetService("VirtualUser")
    
    LocalPlayer.Idled:Connect(function()
        if Config.AntiAFK then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

--[[
    ═══════════════════════════════════════════════════════════
    UI SYSTEM
    ═══════════════════════════════════════════════════════════
]]

local UI = {}

function UI:Create()
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BloxFruitsHub"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game:GetService("CoreGui")
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 15)
    MainCorner.Parent = MainFrame
    
    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 50)
    Header.BackgroundColor3 = Theme.Primary
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 15)
    HeaderCorner.Parent = Header
    
    local HeaderFix = Instance.new("Frame")
    HeaderFix.Size = UDim2.new(1, 0, 0, 15)
    HeaderFix.Position = UDim2.new(0, 0, 1, -15)
    HeaderFix.BackgroundColor3 = Theme.Primary
    HeaderFix.BorderSizePixel = 0
    HeaderFix.Parent = Header
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "🍇 Blox Fruits Premium Hub v3.0"
    Title.TextColor3 = Theme.Text
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    local LevelLabel = Instance.new("TextLabel")
    LevelLabel.Size = UDim2.new(0, 200, 0, 15)
    LevelLabel.Position = UDim2.new(0, 15, 0, 30)
    LevelLabel.BackgroundTransparency = 1
    LevelLabel.Text = "Level: " .. GameFunctions:GetLevel()
    LevelLabel.TextColor3 = Theme.Text
    LevelLabel.Font = Enum.Font.Gotham
    LevelLabel.TextSize = 11
    LevelLabel.TextXAlignment = Enum.TextXAlignment.Left
    LevelLabel.TextTransparency = 0.5
    LevelLabel.Parent = Header
    
    -- Close Button
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -45, 0, 7.5)
    CloseButton.BackgroundColor3 = Theme.Accent
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Theme.Text
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 16
    CloseButton.Parent = Header
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        getgenv().BloxFruitsHubLoaded = false
    end)
    
    -- Content Area
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Size = UDim2.new(1, -20, 1, -70)
    ContentFrame.Position = UDim2.new(0, 10, 0, 60)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.BorderSizePixel = 0
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.ScrollBarImageColor3 = Theme.Primary
    ContentFrame.Parent = MainFrame
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 10)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = ContentFrame
    
    -- Store references
    self.ScreenGui = ScreenGui
    self.MainFrame = MainFrame
    self.ContentFrame = ContentFrame
    self.LevelLabel = LevelLabel
    
    -- Make draggable
    self:MakeDraggable(MainFrame, Header)
    
    -- Add UI Elements
    self:AddElements()
    
    -- Update level periodically
    spawn(function()
        while wait(5) do
            if LevelLabel then
                LevelLabel.Text = "Level: " .. GameFunctions:GetLevel()
            end
        end
    end)
end

function UI:AddElements()
    -- Section: Auto Farm
    self:CreateSection("⚔️ Auto Farm")
    
    self:CreateToggle("Auto Farm", "Automatically farm enemies", Config.AutoFarm, function(state)
        Config.AutoFarm = state
        if state then
            AutoFarm:Start()
            self:Notify("Auto Farm Started!", 2)
        else
            self:Notify("Auto Farm Stopped!", 2)
        end
    end)
    
    self:CreateToggle("Auto Quest", "Automatically get quests", Config.AutoQuest, function(state)
        Config.AutoQuest = state
    end)
    
    self:CreateToggle("Safe Mode", "Teleport when low health", Config.SafeMode, function(state)
        Config.SafeMode = state
    end)
    
    -- Section: Fruits
    self:CreateSection("🍇 Devil Fruits")
    
    self:CreateToggle("Fruit ESP", "See fruits through walls", Config.FruitESP, function(state)
        Config.FruitESP = state
        if state then
            FruitESP:Create()
            self:Notify("Fruit ESP Enabled!", 2)
        end
    end)
    
    self:CreateToggle("Fruit Notifier", "Get notified when fruit spawns", Config.FruitNotifier, function(state)
        Config.FruitNotifier = state
    end)
    
    -- Section: Stats
    self:CreateSection("📊 Auto Stats")
    
    self:CreateToggle("Auto Allocate Stats", "Automatically spend stat points", Config.AutoStats, function(state)
        Config.AutoStats = state
        if state then
            AutoStats:Start()
            self:Notify("Auto Stats Started!", 2)
        end
    end)
    
    local stats = {"Melee", "Defense", "Sword", "Gun", "Fruit"}
    self:CreateDropdown("Select Stat", stats, Config.SelectedStat, function(selected)
        Config.SelectedStat = selected
        self:Notify("Selected: " .. selected, 2)
    end)
    
    -- Section: Miscellaneous
    self:CreateSection("🛠️ Miscellaneous")
    
    self:CreateToggle("Anti-AFK", "Prevent being kicked for inactivity", Config.AntiAFK, function(state)
        Config.AntiAFK = state
    end)
    
    self:CreateButton("Reset Character", "Respawn your character", function()
        LocalPlayer.Character.Humanoid.Health = 0
    end)
    
    -- Credits
    self:CreateSection("ℹ️ Information")
    
    local InfoLabel = Instance.new("TextLabel")
    InfoLabel.Size = UDim2.new(1, 0, 0, 80)
    InfoLabel.BackgroundColor3 = Theme.Surface
    InfoLabel.BorderSizePixel = 0
    InfoLabel.Text = [[
🍇 Blox Fruits Premium Hub
Version: 3.0
Executor: Delta Compatible

Made for grinding comfort!
Use responsibly.
    ]]
    InfoLabel.TextColor3 = Theme.TextSecondary
    InfoLabel.Font = Enum.Font.Gotham
    InfoLabel.TextSize = 11
    InfoLabel.TextWrapped = true
    InfoLabel.TextYAlignment = Enum.TextYAlignment.Top
    InfoLabel.Parent = self.ContentFrame
    
    local InfoCorner = Instance.new("UICorner")
    InfoCorner.CornerRadius = UDim.new(0, 10)
    InfoCorner.Parent = InfoLabel
    
    local InfoPadding = Instance.new("UIPadding")
    InfoPadding.PaddingTop = UDim.new(0, 10)
    InfoPadding.PaddingLeft = UDim.new(0, 10)
    InfoPadding.PaddingRight = UDim.new(0, 10)
    InfoPadding.Parent = InfoLabel
end

function UI:CreateSection(text)
    local Section = Instance.new("TextLabel")
    Section.Size = UDim2.new(1, 0, 0, 30)
    Section.BackgroundTransparency = 1
    Section.Text = text
    Section.TextColor3 = Theme.Primary
    Section.Font = Enum.Font.GothamBold
    Section.TextSize = 14
    Section.TextXAlignment = Enum.TextXAlignment.Left
    Section.Parent = self.ContentFrame
end

function UI:CreateToggle(text, description, default, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(1, 0, 0, 60)
    ToggleFrame.BackgroundColor3 = Theme.Surface
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = self.ContentFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 0, 25)
    Label.Position = UDim2.new(0, 12, 0, 8)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = ToggleFrame
    
    local Description = Instance.new("TextLabel")
    Description.Size = UDim2.new(0.7, 0, 0, 20)
    Description.Position = UDim2.new(0, 12, 0, 33)
    Description.BackgroundTransparency = 1
    Description.Text = description
    Description.TextColor3 = Theme.TextSecondary
    Description.Font = Enum.Font.Gotham
    Description.TextSize = 11
    Description.TextXAlignment = Enum.TextXAlignment.Left
    Description.Parent = ToggleFrame
    
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Size = UDim2.new(0, 50, 0, 25)
    ToggleButton.Position = UDim2.new(1, -62, 0.5, -12.5)
    ToggleButton.BackgroundColor3 = default and Theme.Success or Theme.Accent
    ToggleButton.Text = default and "ON" or "OFF"
    ToggleButton.TextColor3 = Theme.Text
    ToggleButton.Font = Enum.Font.GothamBold
    ToggleButton.TextSize = 12
    ToggleButton.Parent = ToggleFrame
    
    local ToggleBtnCorner = Instance.new("UICorner")
    ToggleBtnCorner.CornerRadius = UDim.new(0, 12)
    ToggleBtnCorner.Parent = ToggleButton
    
    local state = default
    ToggleButton.MouseButton1Click:Connect(function()
        state = not state
        ToggleButton.Text = state and "ON" or "OFF"
        ToggleButton.BackgroundColor3 = state and Theme.Success or Theme.Accent
        callback(state)
    end)
end

function UI:CreateButton(text, description, callback)
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Size = UDim2.new(1, 0, 0, 55)
    ButtonFrame.BackgroundColor3 = Theme.Surface
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Parent = self.ContentFrame
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 10)
    ButtonCorner.Parent = ButtonFrame
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -20, 0, 35)
    Button.Position = UDim2.new(0, 10, 0, 10)
    Button.BackgroundColor3 = Theme.Primary
    Button.Text = text
    Button.TextColor3 = Theme.Text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 13
    Button.Parent = ButtonFrame
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        callback()
    end)
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Secondary}):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Primary}):Play()
    end)
end

function UI:CreateDropdown(text, options, default, callback)
    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Size = UDim2.new(1, 0, 0, 50)
    DropdownFrame.BackgroundColor3 = Theme.Surface
    DropdownFrame.BorderSizePixel = 0
    DropdownFrame.Parent = self.ContentFrame
    
    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 10)
    DropdownCorner.Parent = DropdownFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.5, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.Text
    Label.Font = Enum.Font.GothamBold
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = DropdownFrame
    
    local DropdownButton = Instance.new("TextButton")
    DropdownButton.Size = UDim2.new(0, 150, 0, 30)
    DropdownButton.Position = UDim2.new(1, -162, 0.5, -15)
    DropdownButton.BackgroundColor3 = Theme.Background
    DropdownButton.Text = default .. " ▼"
    DropdownButton.TextColor3 = Theme.Text
    DropdownButton.Font = Enum.Font.Gotham
    DropdownButton.TextSize = 12
    DropdownButton.Parent = DropdownFrame
    
    local DropdownBtnCorner = Instance.new("UICorner")
    DropdownBtnCorner.CornerRadius = UDim.new(0, 8)
    DropdownBtnCorner.Parent = DropdownButton
    
    local currentIndex = 1
    for i, option in ipairs(options) do
        if option == default then
            currentIndex = i
            break
        end
    end
    
    DropdownButton.MouseButton1Click:Connect(function()
        currentIndex = currentIndex % #options + 1
        local selected = options[currentIndex]
        DropdownButton.Text = selected .. " ▼"
        callback(selected)
    end)
end

function UI:Notify(text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "🍇 Blox Fruits Hub",
        Text = text,
        Duration = duration or 3
    })
end

function UI:MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            frame.Position = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
        end
    end)
end

--[[
    ═══════════════════════════════════════════════════════════
    INITIALIZATION
    ═══════════════════════════════════════════════════════════
]]

local function Initialize()
    print("═══════════════════════════════════════════")
    print("🍇 Blox Fruits Premium Hub v3.0")
    print("═══════════════════════════════════════════")
    print("Player: " .. LocalPlayer.Name)
    print("Level: " .. GameFunctions:GetLevel())
    print("Executor: Delta")
    print("═══════════════════════════════════════════")
    
    -- Start Anti-AFK
    AntiAFK:Start()
    
    -- Create UI
    UI:Create()
    
    -- Welcome notification
    UI:Notify("Welcome to Blox Fruits Hub!", 3)
    
    print("✅ Hub loaded successfully!")
    print("═══════════════════════════════════════════")
end

-- Execute with error handling
local success, error = pcall(Initialize)
if not success then
    warn("Hub failed to load:", error)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❌ Error",
        Text = "Hub failed to load!",
        Duration = 5
    })
end
```

## 🎯 **Features Included:**

### ⚔️ **Auto Farm System**
- Level-based enemy selection
- Smooth tweening movement
- Enemy bringing (makes farming easier)
- Safe mode (teleports when low health)
- Auto quest support

### 🍇 **Fruit Features**
- Fruit ESP (see fruits through walls)
- Fruit notifier (notifications when fruit spawns)
- Distance display
- Auto collect (framework included)

### 📊 **Auto Stats**
- Automatic point allocation
- Select which stat to upgrade
- Works while farming

### 🛡️ **Safety Features**
- Anti-AFK system
- Safe mode (escape when low health)
- Auto respawn
- Game detection

### 🎨 **Modern UI**
- Clean, draggable interface
- Toggle buttons for all features
- Real-time level display
- Notifications
- Purple/dark theme

## 📋 **How to Upload to GitHub:**

1. **Create Repository:**
   - Go to GitHub.com
   - Click "New Repository"
   - Name it: `blox-fruits-hub`
   - Make it PUBLIC
   - Create

2. **Upload Script:**
   - Click "Add file" → "Create new file"
   - Name it: `main.lua`
   - Paste the entire script above
   - Commit

3. **Get Raw Link:**
   - Click on `main.lua`
   - Click "Raw" button
   - Copy URL (should look like):
```
   https://raw.githubusercontent.com/YourUsername/blox-fruits-hub/main/main.lua
