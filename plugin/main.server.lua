-- main.server.lua - Repository-based Plugin
local plugin = plugin

-- Services
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")

-- Create toolbar
local toolbar = plugin:CreateToolbar("TeleportSystem")
local installButton = toolbar:CreateButton(
    "Install TeleportSystem",
    "Install complete teleport system from repository",
    "rbxasset://textures/ui/GuiImagePlaceholder.png"
)
local exampleButton = toolbar:CreateButton(
    "Create Example Portals",
    "Create example portals to get started",
    "rbxasset://textures/ui/GuiImagePlaceholder.png"
)

-- Repository configuration
local REPO_CONFIG = {
    version = "2.0.0"
}

-- Helper function for notifications
local function notify(message, duration)
    -- Use pcall to handle Studio environment differences
    local success = pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "TeleportSystem Plugin";
            Text = message;
            Duration = duration or 5;
        })
    end)
    
    if not success then
        -- Fallback to print in Studio
        print("🔔 " .. message)
    end
end

-- Load source from repository files
local function loadSourceFromRepo(fileName)
    -- Return embedded source code directly
    if fileName == "TeleportSystem" then
        return [[
-- TeleportSystem.lua - Modular Teleport System v2.0
local TeleportSystem = {}
TeleportSystem.__index = TeleportSystem

-- Services
local Players = game:GetService("Players")

-- Constructor
function TeleportSystem.new(config)
    local self = setmetatable({}, TeleportSystem)
    
    self.triggerPart = config.triggerPart
    self.destinationName = config.destinationName
    self.cooldowns = {}
    self.cooldownTime = config.cooldownTime or 2
    
    self:setupTeleport()
    return self
end

-- Setup teleport functionality
function TeleportSystem:setupTeleport()
    self.triggerPart.Touched:Connect(function(hit)
        local humanoid = hit.Parent:FindFirstChild("Humanoid")
        if humanoid then
            local player = Players:GetPlayerFromCharacter(hit.Parent)
            if player then
                self:teleportPlayer(player)
            end
        end
    end)
end

-- Teleport player
function TeleportSystem:teleportPlayer(player)
    local playerId = player.UserId
    local currentTime = tick()
    
    if self.cooldowns[playerId] and currentTime - self.cooldowns[playerId] < self.cooldownTime then
        return
    end
    
    self.cooldowns[playerId] = currentTime
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local destination = self:findDestination()
    if destination then
        character.HumanoidRootPart.CFrame = destination.CFrame + Vector3.new(0, 5, 0)
        print("🌀 " .. player.Name .. " teleported!")
    else
        warn("⚠️ Destination not found for portal: " .. self.triggerPart.Name)
    end
end

-- Find destination
function TeleportSystem:findDestination()
    local triggerFolder = self.triggerPart.Parent
    local teleportSystemFolder = triggerFolder.Parent
    
    -- First try same folder
    local sameFolder = triggerFolder:FindFirstChild(self.destinationName)
    if sameFolder then
        return sameFolder
    end
    
    -- Then try other folders
    for _, folder in pairs(teleportSystemFolder:GetChildren()) do
        if folder:IsA("Folder") and folder ~= triggerFolder then
            local destination = folder:FindFirstChild(self.destinationName)
            if destination then
                return destination
            end
        end
    end
    
    return nil
end

return TeleportSystem
]]
    elseif fileName == "Manager" then
        return [[
-- Wait for TeleportSystem to be installed
local function waitForTeleportSystem()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local teleportSystem = replicatedStorage:WaitForChild("TeleportSystem", 10)
    
    if not teleportSystem then
        warn("⚠️ TeleportSystem not found! Please install it using the plugin.")
        return
    end
    
    return require(teleportSystem)
end

-- Wait for TeleportSystem folder in workspace
local function waitForTeleportSystemFolder()
    local workspace = game.Workspace
    local teleportSystemFolder = workspace:WaitForChild("TeleportSystem", 10)
    
    if not teleportSystemFolder then
        warn("⚠️ TeleportSystem folder not found in Workspace!")
        return
    end
    
    return teleportSystemFolder
end

-- Initialize system
local function initializePortals()
    local TeleportSystem = waitForTeleportSystem()
    local teleportSystemFolder = waitForTeleportSystemFolder()
    
    if not TeleportSystem or not teleportSystemFolder then
        return
    end
    
    -- Count existing portals
    local portalCount = 0
    local portalsInitialized = 0
    
    for _, folder in pairs(teleportSystemFolder:GetChildren()) do
        if folder:IsA("Folder") and folder:FindFirstChild("PortalEntry") then
            portalCount = portalCount + 1
            TeleportSystem.new({
                triggerPart = folder.PortalEntry,
                destinationName = "PortalDestination"
            })
            portalsInitialized = portalsInitialized + 1
        end
    end
    
    -- Show appropriate message based on portal count
    if portalCount > 0 then
        print("🎉 " .. portalCount .. " portal(s) ready! Touch to teleport!")
    else
        print("📋 No portals found. Here's how to create them:")
        print("   1️⃣ Create a Folder in Workspace > TeleportSystem")
        print("   2️⃣ Add a Part named 'PortalEntry' (players touch this)")
        print("   3️⃣ Add a Part named 'PortalDestination' (teleport location)")
        print("   4️⃣ Repeat for other portals - they'll auto-pair!")
        print("   💡 Example: PortalA ↔ PortalB, PortalC ↔ PortalD")
        print("   🔄 Portals in same folder teleport to each other")
    end
end

-- Start initialization
initializePortals()
]]
    else
        error("Unknown source file: " .. fileName)
    end
end

-- Create example portal structure
local function createExamplePortals()
    local workspace = game.Workspace
    local teleportSystemFolder = workspace:FindFirstChild("TeleportSystem")
    
    if not teleportSystemFolder then
        teleportSystemFolder = Instance.new("Folder")
        teleportSystemFolder.Name = "TeleportSystem"
        teleportSystemFolder.Parent = workspace
        print("📁 Created TeleportSystem folder")
    end
    
    -- Check if examples already exist
    local hasExamples = teleportSystemFolder:FindFirstChild("PortalA") or teleportSystemFolder:FindFirstChild("PortalB")
    if hasExamples then
        print("📋 Example portals already exist!")
        notify("📋 Example portals already exist!", 3)
        return
    end
    
    local function createPortal(name, position, color)
        local folder = Instance.new("Folder")
        folder.Name = name
        folder.Parent = teleportSystemFolder
        
        -- Trigger part
        local trigger = Instance.new("Part")
        trigger.Name = "PortalEntry"
        trigger.Size = Vector3.new(6, 1, 6)
        trigger.Position = position
        trigger.Color = color
        trigger.Material = Enum.Material.Neon
        trigger.Shape = Enum.PartType.Cylinder
        trigger.CanCollide = false
        trigger.Anchored = true
        trigger.Parent = folder
        
        -- Destination part
        local destination = Instance.new("Part")
        destination.Name = "PortalDestination"
        destination.Size = Vector3.new(4, 0.5, 4)
        destination.Position = position + Vector3.new(0, -3, 0)
        destination.Color = color
        destination.Material = Enum.Material.ForceField
        destination.Transparency = 0.5
        destination.CanCollide = false
        destination.Anchored = true
        destination.Parent = folder
        
        print("🌀 Created portal: " .. name)
    end
    
    createPortal("PortalA", Vector3.new(-20, 10, 0), Color3.new(0, 0.5, 1))
    createPortal("PortalB", Vector3.new(20, 10, 0), Color3.new(0, 1, 0.5))
    
    print("✨ Example portals created! Touch to test!")
    notify("✨ Example portals created! Touch to test!", 5)
end

-- Ensure TeleportSystem folder exists (minimal setup)
local function ensureTeleportSystemFolder()
    local workspace = game.Workspace
    local teleportSystemFolder = workspace:FindFirstChild("TeleportSystem")
    
    if not teleportSystemFolder then
        teleportSystemFolder = Instance.new("Folder")
        teleportSystemFolder.Name = "TeleportSystem"
        teleportSystemFolder.Parent = workspace
        print("📁 Created TeleportSystem folder")
    end
    
    return teleportSystemFolder
end

-- Main installation function
local function installTeleportSystem()
    print("🚀 Installing TeleportSystem from repository...")
    notify("🚀 Installing TeleportSystem...", 3)
    
    local success, error = pcall(function()
        -- 1. Ensure TeleportSystem folder exists (but don't create example portals)
        ensureTeleportSystemFolder()
        
        -- 2. Install ModuleScript in ReplicatedStorage
        local replicatedStorage = game:GetService("ReplicatedStorage")
        local existingModule = replicatedStorage:FindFirstChild("TeleportSystem")
        
        if existingModule then
            existingModule:Destroy()
            print("🔄 Removed existing TeleportSystem module")
        end
        
        local moduleScript = Instance.new("ModuleScript")
        moduleScript.Name = "TeleportSystem"
        moduleScript.Source = loadSourceFromRepo("TeleportSystem")
        moduleScript.Parent = replicatedStorage
        print("✅ TeleportSystem ModuleScript installed")
        
        -- 3. Install Manager Script in ServerScriptService (AFTER folder exists)
        local serverScriptService = game:GetService("ServerScriptService")
        local existingManager = serverScriptService:FindFirstChild("TeleportSystemManager")
        
        if existingManager then
            existingManager:Destroy()
            print("🔄 Removed existing manager")
        end
        
        local managerScript = Instance.new("ServerScript")
        managerScript.Name = "TeleportSystemManager"
        managerScript.Source = loadSourceFromRepo("Manager")
        managerScript.Parent = serverScriptService
        print("✅ TeleportSystemManager installed")
        
        print("🎉 TeleportSystem installation complete!")
        print("📦 Version: " .. REPO_CONFIG.version)
        print("💡 Use 'Create Example Portals' button to get started!")
        
        notify("✅ Installation complete! Click 'Create Example Portals' to start", 6)
    end)
    
    if not success then
        warn("❌ Installation failed: " .. tostring(error))
        notify("❌ Installation failed: " .. tostring(error), 8)
    end
end

-- Connect buttons
installButton.Click:Connect(installTeleportSystem)
-- Connect buttons
installButton.Click:Connect(installTeleportSystem)
exampleButton.Click:Connect(createExamplePortals)

print("🔌 TeleportSystem Repository Plugin loaded!")
print("📦 Version: " .. REPO_CONFIG.version)
print("💡 Click 'Install TeleportSystem' to get started!")