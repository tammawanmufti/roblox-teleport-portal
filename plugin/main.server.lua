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

-- Repository configuration
local REPO_CONFIG = {
    version = "2.0.0",
    repoPath = script.Parent.Parent, -- Root of this repository
    
    -- Source files in Studio-like structure
    sources = {
        TeleportSystem = "src/ReplicatedStorage/TeleportSystem.lua",
        Manager = "src/ServerScriptService/TeleportSystemManager.lua"
    }
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
    local filePath = REPO_CONFIG.sources[fileName]
    if not filePath then
        error("Source file not found: " .. fileName)
    end
    
    -- Navigate to source file
    local pathParts = {}
    for part in string.gmatch(filePath, "[^/]+") do
        table.insert(pathParts, part)
    end
    
    local currentObj = REPO_CONFIG.repoPath
    for i, part in ipairs(pathParts) do
        if i == #pathParts then
            -- Last part - look for source file (remove .lua extension)
            local luaFileName = part:gsub("%.lua$", "")
            local sourceObj = currentObj:FindFirstChild(luaFileName)
            
            if sourceObj then
                if sourceObj:IsA("StringValue") then
                    return sourceObj.Value
                elseif sourceObj:IsA("ModuleScript") or sourceObj:IsA("Script") or sourceObj:IsA("LocalScript") then
                    return sourceObj.Source
                end
            end
        else
            if currentObj then
                currentObj = currentObj:FindFirstChild(part)
                if not currentObj then 
                    break 
                end
            else
                break
            end
        end
    end
    
    error("Could not load source: " .. filePath)
end

-- Create example portal structure
local function createExamplePortals()
    local workspace = game.Workspace
    local teleportSystemFolder = workspace:FindFirstChild("TeleportSystem")
    
    if teleportSystemFolder then
        print("📁 TeleportSystem folder already exists")
        return
    end
    
    teleportSystemFolder = Instance.new("Folder")
    teleportSystemFolder.Name = "TeleportSystem"
    teleportSystemFolder.Parent = workspace
    
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
end

-- Main installation function
local function installTeleportSystem()
    print("🚀 Installing TeleportSystem from repository...")
    notify("🚀 Installing TeleportSystem...", 3)
    
    local success, error = pcall(function()
        -- 1. Create example portals FIRST (before installing manager)
        createExamplePortals()
        
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
        print("💡 Touch portal parts to teleport!")
        
        notify("✅ Installation complete! Check Workspace > TeleportSystem", 5)
    end)
    
    if not success then
        warn("❌ Installation failed: " .. tostring(error))
        notify("❌ Installation failed: " .. tostring(error), 8)
    end
end

-- Connect button
installButton.Click:Connect(installTeleportSystem)

print("🔌 TeleportSystem Repository Plugin loaded!")
print("📦 Version: " .. REPO_CONFIG.version)
print("💡 Click 'Install TeleportSystem' to get started!")