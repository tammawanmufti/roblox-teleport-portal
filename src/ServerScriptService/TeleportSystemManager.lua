local TeleportSystem = require(game.ReplicatedStorage.TeleportSystem)
local teleportSystemFolder = game.Workspace.TeleportSystem

for _, folder in pairs(teleportSystemFolder:GetChildren()) do
	if folder:IsA("Folder") and folder:FindFirstChild("PortalEntry") then
		TeleportSystem.new({
			triggerPart = folder.PortalEntry,
			destinationName = "PortalDestination"
		})
	end
end