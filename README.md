# 🌀 TeleportSystem Plugin

Professional teleport portal system for Roblox with one-click Studio installation.

## ⚡ Quick Start

### Installation
```bash
# Clone to Roblox Plugins directory
cd "~/Library/Application Support/Roblox/Plugins/"    # Mac
# cd "%LOCALAPPDATA%\Roblox\Plugins\"                 # Windows

git clone https://github.com/yourname/roblox-teleportsystem.git TeleportSystem
```

### Usage
1. **Restart Roblox Studio**
2. **Click "Install TeleportSystem" button** in toolbar
3. **Touch glowing portal parts** to teleport! 🌀

## 🎯 Features

- ✅ **Same-folder teleportation** (Entry → Destination in same folder)
- ✅ **Cooldown system** (prevents teleport spam)
- ✅ **Visual & sound effects** (explosions + audio)
- ✅ **Auto-setup** (creates example portals)
- ✅ **Debug logging** (helpful console messages)

## 🔄 Updates

```bash
cd "~/Library/Application Support/Roblox/Plugins/TeleportSystem"
git pull origin main
# Restart Studio → Updated!
```

## 🛠️ Customization

Edit `src/TeleportSystem.lua` to modify:
- Cooldown time (`cooldownTime = 2`)
- Spawn height (`heightOffset = 5`) 
- Sound effects (`soundId = "..."`)
- Debug mode (`debugEnabled = true`)

## 📁 What Gets Installed

```
ReplicatedStorage/TeleportSystem (ModuleScript)
ServerScriptService/TeleportSystemManager (ServerScript)
Workspace/TeleportSystem/
├── PortalA/
│   ├── PortalEntry → PortalDestination
│   └── PortalDestination
└── PortalB/
    ├── PortalEntry → PortalDestination
    └── PortalDestination
```

## 👥 Team Usage

Share repository URL → Everyone clones → Auto-sync updates via git pull

## 📄 License

MIT - Free to use and modify!