@echo off
REM install-plugin.bat - Windows installer script

echo 🚀 Installing TeleportSystem Plugin...

REM Set plugins directory
set "PLUGINS_DIR=%LOCALAPPDATA%\Roblox\Plugins"

REM Create plugins directory if it doesn't exist
if not exist "%PLUGINS_DIR%" mkdir "%PLUGINS_DIR%"

REM Clone or update repository
set "PLUGIN_PATH=%PLUGINS_DIR%\TeleportSystem"

if exist "%PLUGIN_PATH%" (
    echo 📦 Updating existing plugin...
    cd /d "%PLUGIN_PATH%"
    git pull origin main
) else (
    echo 📥 Installing plugin...
    cd /d "%PLUGINS_DIR%"
    git clone https://github.com/tammawanmufti/roblox-teleport-portal.git TeleportSystem
)

echo ✅ Installation complete!
echo 🔄 Please restart Roblox Studio
echo 💡 Look for 'TeleportSystem' toolbar and click 'Install TeleportSystem'
pause