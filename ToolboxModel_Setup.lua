-- ToolboxModel_Setup.lua  
-- Script untuk membuat model yang bisa di-upload ke Toolbox

-- Instruksi untuk membuat Toolbox Model:
-- 1. Jalankan script ini di Command Bar Roblox Studio
-- 2. Select model "TeleportSystemKit" yang dibuat
-- 3. Right-click → "Save to Roblox" → Upload sebagai Model
-- 4. Set Title: "TeleportSystem - Complete Portal Kit"
-- 5. Add tags: teleport, portal, system, easy, plugin

local function createToolboxModel()
    -- Create main model
    local model = Instance.new("Model")
    model.Name = "TeleportSystemKit"
    model.Parent = workspace
    
    -- Create ModuleScript
    local moduleScript = Instance.new("ModuleScript")
    moduleScript.Name = "TeleportSystem"
    moduleScript.Source = [[ -- Paste TeleportSystem.lua source here ]]
    moduleScript.Parent = model
    
    -- Create ServerScript  
    local serverScript = Instance.new("ServerScript")
    serverScript.Name = "AutoSetup"
    serverScript.Source = [[
        -- Auto-setup script for Toolbox model
        local TeleportSystem = script.Parent:FindFirstChild("TeleportSystem")
        
        -- Move ModuleScript to ReplicatedStorage
        TeleportSystem.Parent = game.ReplicatedStorage
        
        -- Create manager script in ServerScriptService
        local managerScript = Instance.new("ServerScript")
        managerScript.Name = "TeleportSystemManager"
        managerScript.Source = [[
            local TeleportSystem = require(game.ReplicatedStorage.TeleportSystem)
            
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant.Name == "PortalEntry" and descendant:IsA("BasePart") then
                    TeleportSystem.new({
                        triggerPart = descendant,
                        destinationName = "PortalDestination"
                    })
                    print("✅ Auto-portal: " .. (descendant.Parent and descendant.Parent.Name or "Unknown"))
                end
            end
            
            print("🎉 All portals from Toolbox model are active!")
        ]]
        managerScript.Parent = game.ServerScriptService
        
        -- Self-cleanup
        script.Parent:Destroy()
        print("📦 TeleportSystem installed from Toolbox model!")
    ]]
    serverScript.Parent = model
    
    -- Create example portal structure
    local portalFolder = Instance.new("Folder")
    portalFolder.Name = "ExamplePortals"
    portalFolder.Parent = model
    
    local function createPortal(name, position, color)
        local folder = Instance.new("Folder")
        folder.Name = name
        folder.Parent = portalFolder
        
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
        
        local dest = Instance.new("Part")
        dest.Name = "PortalDestination"
        dest.Size = Vector3.new(4, 0.5, 4)
        dest.Position = position + Vector3.new(0, -3, 0)
        dest.Color = color
        dest.Material = Enum.Material.ForceField
        dest.Transparency = 0.5
        dest.CanCollide = false
        dest.Anchored = true
        dest.Parent = folder
    end
    
    createPortal("PortalA", Vector3.new(-15, 10, 0), Color3.new(0, 0.5, 1))
    createPortal("PortalB", Vector3.new(15, 10, 0), Color3.new(0, 1, 0.5))
    
    -- Create instruction GUI
    local gui = Instance.new("BillboardGui")
    gui.Name = "Instructions"
    gui.Size = UDim2.new(8, 0, 4, 0)
    gui.StudsOffset = Vector3.new(0, 10, 0)
    gui.Parent = model
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 1, 0)
    frame.BackgroundColor3 = Color3.new(0, 0, 0)
    frame.BackgroundTransparency = 0.3
    frame.Parent = gui
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "🌀 TeleportSystem Kit\n\n✅ Drag this model to workspace\n✅ Press Play to auto-install\n✅ Touch portal parts to teleport!\n\n📦 By GitHub Copilot"
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextScaled = true
    label.Font = Enum.Font.SourceSansBold
    label.Parent = frame
    
    print("📦 Toolbox model created: TeleportSystemKit")
    print("📋 Next steps:")
    print("   1. Select the model")
    print("   2. Right-click → Save to Roblox")
    print("   3. Upload with title: 'TeleportSystem - Complete Portal Kit'")
    print("   4. Add tags: teleport, portal, system, easy")
end

-- Run this in Command Bar
createToolboxModel()