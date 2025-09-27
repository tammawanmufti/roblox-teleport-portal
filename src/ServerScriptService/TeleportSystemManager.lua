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