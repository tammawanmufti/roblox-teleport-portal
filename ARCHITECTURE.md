# 🔧 Architecture Explanation

## 🎯 **How the Plugin System Works:**

### **Repository Structure (Development):**
```
roblox-teleportsystem/
├── plugin/                           ← Plugin definition
│   ├── plugin.json                  ← Plugin metadata  
│   └── main.server.lua              ← Plugin installer
├── src/                             ← Source code (mirrors Studio)
│   ├── ReplicatedStorage/
│   │   └── TeleportSystem.lua       ← ModuleScript source
│   └── ServerScriptService/
│       └── TeleportSystemManager.lua ← ServerScript source
└── default.project.json             ← Rojo mapping (optional)
```

### **Plugin Installation Process:**

1. **Plugin Reads Source Files:**
   ```lua
   -- Plugin reads from repository files
   local moduleSource = readFile("src/ReplicatedStorage/TeleportSystem.lua")
   local managerSource = readFile("src/ServerScriptService/TeleportSystemManager.lua")
   ```

2. **Plugin Creates Studio Objects:**
   ```lua
   -- Create ModuleScript in ReplicatedStorage
   local moduleScript = Instance.new("ModuleScript")
   moduleScript.Name = "TeleportSystem"
   moduleScript.Source = moduleSource  -- Paste the source code
   moduleScript.Parent = game.ReplicatedStorage
   
   -- Create ServerScript in ServerScriptService
   local serverScript = Instance.new("ServerScript")  
   serverScript.Name = "TeleportSystemManager"
   serverScript.Source = managerSource  -- Paste the source code
   serverScript.Parent = game.ServerScriptService
   ```

3. **Final Studio Structure:**
   ```
   Studio Game:
   ├── ReplicatedStorage/
   │   └── TeleportSystem (ModuleScript)     ← Created by plugin
   └── ServerScriptService/
       └── TeleportSystemManager (ServerScript) ← Created by plugin
   ```

## 🔄 **Why This Architecture:**

### **✅ Benefits:**
- **Version Control:** Source files tracked in Git
- **Team Collaboration:** Everyone sees same source structure
- **Easy Updates:** Edit source → Plugin installs to Studio
- **Clear Mapping:** `src/` structure mirrors Studio structure
- **Development Friendly:** Use any editor (VS Code, etc.)

### **🔄 Workflow:**
1. **Developer edits** `src/ReplicatedStorage/TeleportSystem.lua`
2. **Git commit & push** changes
3. **Team pulls** updates via `git pull`
4. **Click plugin button** in Studio → Updated code installed!

### **🎯 Key Insight:**
- **Repository = Development Environment** (editable source)
- **Plugin = Deployment Tool** (installs to Studio)
- **Studio = Runtime Environment** (where code actually runs)

## 🔧 **Alternative: Rojo Sync (Optional)**

If you want live sync during development:

```bash
# Install Rojo
npm install -g rojo

# Start sync server
rojo serve

# Connect from Studio → Live sync!
```

But the plugin approach is better for distribution because:
- ✅ No external dependencies
- ✅ Works on any machine
- ✅ One-click installation
- ✅ Version controlled

## 🎉 **Best of Both Worlds:**

- **Development:** Edit `src/` files with proper Studio structure
- **Distribution:** Plugin reads `src/` and installs to Studio
- **Team Sync:** Git handles version control and sharing
- **User Experience:** One-click install, no setup needed