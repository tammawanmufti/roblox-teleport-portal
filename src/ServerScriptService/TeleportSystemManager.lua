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
    
    print("🌟 Initializing teleport portals...")
    
    for _, folder in pairs(teleportSystemFolder:GetChildren()) do
        if folder:IsA("Folder") and folder:FindFirstChild("PortalEntry") then
            TeleportSystem.new({
                triggerPart = folder.PortalEntry,
                destinationName = "PortalDestination"
            })
            print("✨ Portal initialized: " .. folder.Name)
        end
    end
    
    print("🎉 All portals ready!")
end

-- Start initialization
initializePortals()