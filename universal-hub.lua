--[[
    ═══════════════════════════════════════════
    🌟 UNIVERSAL HUB LOADER
    ═══════════════════════════════════════════
    
    Quick Load:
    Copy and execute this entire script in Delta!
]]

-- Configuration
local SCRIPT_URL = "https://raw.githubusercontent.com/YourUsername/YourRepo/main/hub.lua"
local HUB_NAME = "Universal Hub"
local VERSION = "2.0"

-- Loading Screen
local function ShowLoadingScreen()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LoadingScreen"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 150)
    Frame.Position = UDim2.new(0.5, -150, 0.5, -75)
    Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 15)
    Corner.Parent = Frame
    
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 50)
    Title.BackgroundTransparency = 1
    Title.Text = "🌟 " .. HUB_NAME
    Title.TextColor3 = Color3.fromRGB(138, 43, 226)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20
    Title.Parent = Frame
    
    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -20, 0, 30)
    Status.Position = UDim2.new(0, 10, 0, 60)
    Status.BackgroundTransparency = 1
    Status.Text = "Loading..."
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 14
    Status.Parent = Frame
    
    local Progress = Instance.new("TextLabel")
    Progress.Size = UDim2.new(1, -20, 0, 20)
    Progress.Position = UDim2.new(0, 10, 0, 100)
    Progress.BackgroundTransparency = 1
    Progress.Text = "Please wait..."
    Progress.TextColor3 = Color3.fromRGB(180, 180, 190)
    Progress.Font = Enum.Font.Gotham
    Progress.TextSize = 12
    Progress.Parent = Frame
    
    return ScreenGui, Status, Progress
end

-- Main Loading Function
local function LoadHub()
    print("═══════════════════════════════════════════")
    print("🌟 " .. HUB_NAME .. " v" .. VERSION)
    print("═══════════════════════════════════════════")
    
    local LoadingScreen, Status, Progress = ShowLoadingScreen()
    
    -- Step 1: Check Environment
    Status.Text = "Checking environment..."
    wait(0.5)
    
    if not game:GetService("HttpService").HttpEnabled then
        Progress.Text = "❌ HTTP not enabled!"
        wait(2)
        LoadingScreen:Destroy()
        return
    end
    
    -- Step 2: Download Script
    Status.Text = "Downloading script..."
    Progress.Text = "Connecting to server..."
    wait(0.5)
    
    local success, script = pcall(function()
        return game:HttpGet(SCRIPT_URL, true)
    end)
    
    if not success then
        Status.Text = "❌ Download failed!"
        Progress.Text = "Error: " .. tostring(script)
        wait(3)
        LoadingScreen:Destroy()
        error("Failed to download script: " .. tostring(script))
        return
    end
    
    -- Step 3: Verify Script
    Status.Text = "Verifying script..."
    Progress.Text = "Size: " .. #script .. " bytes"
    wait(0.5)
    
    if #script < 100 then
        Status.Text = "❌ Invalid script!"
        Progress.Text = "Script too small or corrupted"
        wait(2)
        LoadingScreen:Destroy()
        return
    end
    
    -- Step 4: Execute
    Status.Text = "Executing..."
    Progress.Text = "Initializing hub..."
    wait(0.5)
    
    local executeSuccess, executeError = pcall(function()
        loadstring(script)()
    end)
    
    if not executeSuccess then
        Status.Text = "❌ Execution failed!"
        Progress.Text = "Error: " .. tostring(executeError)
        wait(3)
        LoadingScreen:Destroy()
        error("Failed to execute: " .. tostring(executeError))
        return
    end
    
    -- Success!
    Status.Text = "✅ Loaded successfully!"
    Progress.Text = "Enjoy! 🎮"
    wait(1)
    LoadingScreen:Destroy()
    
    print("✅ " .. HUB_NAME .. " loaded successfully!")
    print("═══════════════════════════════════════════")
end

-- Execute with error handling
local finalSuccess, finalError = pcall(LoadHub)

if not finalSuccess then
    warn("═══════════════════════════════════════════")
    warn("❌ LOADER ERROR")
    warn("═══════════════════════════════════════════")
    warn(tostring(finalError))
    warn("═══════════════════════════════════════════")
end
