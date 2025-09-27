-- TeleportSystem.lua (ModuleScript) - Simplified but compatible version
-- Class-based teleport system yang bisa di-import dan digunakan berulang
-- Letakkan di ReplicatedStorage atau ServerStorage sebagai ModuleScript

local TeleportSystem = {}
TeleportSystem.__index = TeleportSystem

-- Services
local Players = game:GetService("Players")

-- Static variables (shared across all instances)
local globalCooldowns = {} -- Shared cooldown table

-- Constructor - membuat instance baru TeleportSystem
function TeleportSystem.new(config)
    config = config or {}
    
    local self = setmetatable({}, TeleportSystem)
    
    -- Instance properties dari constructor (tetap sama)
    self.triggerPart = config.triggerPart or error("triggerPart required in constructor")
    self.destinationName = config.destinationName or config.destination or error("destinationName required in constructor")
    self.cooldownTime = config.cooldownTime or config.cooldown or 2
    self.heightOffset = config.heightOffset or config.height or 5
    self.soundId = config.soundId or config.sound or "rbxasset://sounds/electronicpingshort.wav"
    self.soundVolume = config.soundVolume or config.volume or 0.5
    self.effectEnabled = config.effectEnabled ~= false -- default true
    self.debugEnabled = config.debugEnabled ~= false -- default true
    
    -- Optional: Auto-detect destination jika tidak ada
    if not self.destinationName and config.autoDetect ~= false then
        self.destinationName = self:_autoDetectDestination(self.triggerPart.Name)
    end
    
    -- Optional: Search locations (tetap ada untuk compatibility)
    self.searchFolders = config.searchFolders or {"Portal", "Portals", "Teleporters"}
    
    -- Instance state
    self.isActive = true
    self.connection = nil
    self._instanceId = tostring(self):match("table: 0x(%w+)") -- Unique ID untuk instance
    
    -- Setup teleport
    self:_initialize()
    
    return self
end

-- Private method: Auto-detect destination name (simplified)
function TeleportSystem:_autoDetectDestination(partName)
    if string.find(partName, "PortalA") then
        return "PortalB_Destination"
    elseif string.find(partName, "PortalB") then
        return "PortalA_Destination"
    elseif string.find(partName, "Entry") then
        return "PortalDestination"
    else
        return partName .. "_Destination"
    end
end

-- Private method: Find destination part (simplified)
function TeleportSystem:_findDestinationPart()
    -- Simple same-folder logic first
    if self.destinationName == "PortalDestination" then
        local triggerFolder = self.triggerPart.Parent
        if triggerFolder and triggerFolder:IsA("Folder") then
            local destination = triggerFolder:FindFirstChild(self.destinationName)
            if destination then
                if self.debugEnabled then
                    print("🌀 [" .. self.triggerPart.Name .. "] Same-folder destination found: " .. triggerFolder.Name .. "/" .. destination.Name)
                end
                return destination
            end
        end
    end
    
    -- Simple fallback search
    return workspace:FindFirstChild(self.destinationName)
end

-- Private method: Create teleport effect (simplified)
function TeleportSystem:_createEffect(position)
    if not self.effectEnabled then return end
    
    local effect = Instance.new("Explosion")
    effect.Position = position
    effect.BlastRadius = 0
    effect.BlastPressure = 0
    effect.Visible = false
    effect.Parent = workspace
end

-- Private method: Play teleport sound (simplified)
function TeleportSystem:_playSound(character)
    local sound = Instance.new("Sound")
    sound.SoundId = self.soundId
    sound.Volume = self.soundVolume
    sound.Parent = character:FindFirstChild("Head") or character:FindFirstChild("HumanoidRootPart")
    sound:Play()
    
    game:GetService("Debris"):AddItem(sound, 2) -- Auto cleanup
end

-- Private method: Check cooldown (simplified)
function TeleportSystem:_checkCooldown(player)
    local cooldownKey = player.UserId .. "_" .. self._instanceId
    local currentTime = tick()
    
    if globalCooldowns[cooldownKey] and currentTime - globalCooldowns[cooldownKey] < self.cooldownTime then
        return false -- Still in cooldown
    end
    
    globalCooldowns[cooldownKey] = currentTime
    return true -- Cooldown passed
end

-- Private method: Debug print (simplified)
function TeleportSystem:_debug(message)
    if self.debugEnabled then
        print("🌀 [" .. self.triggerPart.Name .. "] " .. message)
    end
end

-- Public method: Teleport a player (simplified)
function TeleportSystem:teleportPlayer(player, destinationPart)
    local character = player.Character
    if not character then return false, "No character" end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return false, "No HumanoidRootPart" end
    
    -- Calculate destination position
    local destinationPosition = destinationPart.Position + Vector3.new(0, destinationPart.Size.Y/2 + self.heightOffset, 0)
    
    -- Create effects
    self:_createEffect(humanoidRootPart.Position) -- Start position
    
    -- Teleport
    humanoidRootPart.CFrame = CFrame.new(destinationPosition)
    
    -- End effects
    self:_createEffect(destinationPosition) -- End position
    self:_playSound(character)
    
    self:_debug(player.Name .. " teleported to " .. self.destinationName)
    return true, "Success"
end

-- Private method: Handle part touched event (simplified)
function TeleportSystem:_onPartTouched(hit)
    if not self.isActive then return end
    
    -- Check if it's a player
    local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    
    local player = Players:GetPlayerFromCharacter(hit.Parent)
    if not player then return end
    
    -- Check cooldown
    if not self:_checkCooldown(player) then
        return -- Still in cooldown
    end
    
    -- Find destination
    local destinationPart = self:_findDestinationPart()
    if not destinationPart then
        self:_debug("❌ Destination '" .. self.destinationName .. "' not found!")
        return
    end
    
    -- Teleport player
    local success, message = self:teleportPlayer(player, destinationPart)
    if not success then
        warn("🌀 [" .. self.triggerPart.Name .. "] Teleport failed: " .. message)
    end
end

-- Private method: Initialize the teleport system (simplified)
function TeleportSystem:_initialize()
    -- Connect touch event
    self.connection = self.triggerPart.Touched:Connect(function(hit)
        self:_onPartTouched(hit)
    end)
    
    self:_debug("Initialized - Target: " .. self.destinationName)
    
    -- Simple destination check
    local destination = self:_findDestinationPart()
    if not destination then
        self:_debug("⚠️ Warning: Destination '" .. self.destinationName .. "' not found!")
    else
        self:_debug("✅ Destination found: " .. destination.Name)
    end
end

-- Public method: Enable/disable teleport
function TeleportSystem:setActive(active)
    self.isActive = active
    self:_debug(active and "Activated" or "Deactivated")
end

-- Public method: Update destination
function TeleportSystem:setDestination(newDestination)
    self.destinationName = newDestination
    self:_debug("Destination changed to: " .. newDestination)
end

-- Public method: Update cooldown
function TeleportSystem:setCooldown(newCooldown)
    self.cooldownTime = newCooldown
    self:_debug("Cooldown changed to: " .. newCooldown .. "s")
end

-- Public method: Get current configuration
function TeleportSystem:getConfig()
    return {
        triggerPart = self.triggerPart,
        destinationName = self.destinationName,
        cooldownTime = self.cooldownTime,
        heightOffset = self.heightOffset,
        soundId = self.soundId,
        soundVolume = self.soundVolume,
        effectEnabled = self.effectEnabled,
        debugEnabled = self.debugEnabled,
        isActive = self.isActive
    }
end

-- Public method: Cleanup (destroy instance)
function TeleportSystem:destroy()
    if self.connection then
        self.connection:Disconnect()
        self.connection = nil
    end
    
    -- Clear cooldowns for this instance
    for key, _ in pairs(globalCooldowns) do
        if string.find(key, self._instanceId) then
            globalCooldowns[key] = nil
        end
    end
    
    self:_debug("Destroyed")
    setmetatable(self, nil)
end

-- Static method: Create multiple teleports from config table
function TeleportSystem.createMultiple(configs)
    local instances = {}
    
    for i, config in ipairs(configs) do
        local instance = TeleportSystem.new(config)
        table.insert(instances, instance)
    end
    
    return instances
end

-- Static method: Get version info
function TeleportSystem.getVersion()
    return {
        version = "2.0.0-Simple",
        author = "GitHub Copilot",
        description = "Simplified modular teleport system for Roblox"
    }
end

return TeleportSystem