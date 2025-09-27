#!/bin/bash
# install-plugin.sh - Quick installer script

echo "🚀 Installing TeleportSystem Plugin..."

# Detect OS and set plugins directory
if [[ "$OSTYPE" == "darwin"* ]]; then
    # Mac OS
    PLUGINS_DIR="$HOME/Library/Application Support/Roblox/Plugins"
else
    # Windows (Git Bash/WSL)
    PLUGINS_DIR="$LOCALAPPDATA/Roblox/Plugins"
fi

# Create plugins directory if it doesn't exist
mkdir -p "$PLUGINS_DIR"

# Clone or update repository
PLUGIN_PATH="$PLUGINS_DIR/TeleportSystem"

if [ -d "$PLUGIN_PATH" ]; then
    echo "📦 Updating existing plugin..."
    cd "$PLUGIN_PATH"
    git pull origin main
else
    echo "📥 Installing plugin..."
    cd "$PLUGINS_DIR"
    git clone https://github.com/yourname/roblox-teleportsystem.git TeleportSystem
fi

echo "✅ Installation complete!"
echo "🔄 Please restart Roblox Studio"
echo "💡 Look for 'TeleportSystem' toolbar and click 'Install TeleportSystem'"