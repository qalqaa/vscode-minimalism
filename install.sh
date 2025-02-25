#!/bin/bash

echo '                     /$$                                                '
echo '                    | $$                                                '
echo '  /$$$$$$   /$$$$$$ | $$  /$$$$$$   /$$$$$$                             '
echo ' /$$__  $$ |____  $$| $$ /$$__  $$ |____  $$                            '
echo '| $$  \ $$  /$$$$$$$| $$| $$  \ $$  /$$$$$$$                            '
echo '| $$  | $$ /$$__  $$| $$| $$  | $$ /$$__  $$                            '
echo '|  $$$$$$$|  $$$$$$$| $$|  $$$$$$$|  $$$$$$$                            '
echo ' \____  $$ \_______/|__/ \____  $$ \_______/                            '
echo '      | $$                    | $$                                      '
echo '      | $$                    | $$                                      '
echo '      |__/                    |__/                                      '
echo ""
echo "WELCOME TO QALQA'S VSCODE SETUP SCRIPT"
echo "======================================"
echo ""

default_extensions=(
    "be5invis.vscode-custom-css"
    "catppuccin.catppuccin-vsc"
    "catppuccin.catppuccin-vsc-icons"
)

declare -a optional_extensions

ask_to_install() {
    local extension_name="$1"
    local extension_id="$2"

    echo -n "Install $extension_name? (Y/N): "
    while true; do
        read -n1 -s key
        case "$key" in
        [Yy])
            printf "\e[32m✓\e[0m\n"
            optional_extensions+=("$extension_id")
            break
            ;;
        [Nn])
            printf "\e[31mx\e[0m\n"
            break
            ;;
        esac
    done
}

ask_to_install "Animations (VSCode Animations)" "brandonkirbyson.vscode-animations"
ask_to_install "Transparency (Vibrancy Continued)" "illixion.vscode-vibrancy-continued"

if [ ${#optional_extensions[@]} -gt 0 ]; then
    for ext in "${optional_extensions[@]}"; do
        code --install-extension "$ext"
    done
fi

echo "Installing default extensions..."
for ext in "${default_extensions[@]}"; do
    code --install-extension "$ext"
done

echo ""
printf "\e[32m======================================\e[0m\n"
printf "\e[32m  ALL EXTENSIONS HAVE BEEN INSTALLED  \e[0m\n"
printf "\e[32m======================================\e[0m\n"
echo ""

echo "Are you using the standard VSCode settings layout? (Y/N): "
read -n1 -s std_answer
echo
if [[ $std_answer =~ [Yy] ]]; then
    OS_TYPE=$(uname)

    case "$OS_TYPE" in
    "Linux")
        USER_SETTINGS_DIR="$HOME/.config/Code/User"
        ;;
    "Darwin")
        USER_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
        ;;
    "MINGW32_NT"* | "MINGW64_NT"* | "CYGWIN"*)
        USER_SETTINGS_DIR="${APPDATA:-$HOME/AppData/Roaming}/Code/User"
        ;;
    *)
        echo "Unknown operating system, please input the full path to the settings directory manually!"
        read -p "Input the full path to the VSCode settings directory: " USER_SETTINGS_DIR
        ;;
    esac
else
    read -p "Input the full path to the settings directory: " USER_SETTINGS_DIR
fi

echo "User settings directory: $USER_SETTINGS_DIR"

SETTINGS_FILE="./settings-ot.json"
TARGET_SETTINGS="$USER_SETTINGS_DIR/settings.json"

if [ -f "$SETTINGS_FILE" ]; then
    echo "Updating settings.json..."
    if [ -f "$TARGET_SETTINGS" ]; then
        tmp_file=$(mktemp)
        jq -s '.[1] as $user | 
               (.[0] | to_entries | map(select(.key as $k | ($user | has($k) | not))) | from_entries) as $diff |
               $user + $diff' "$SETTINGS_FILE" "$TARGET_SETTINGS" >"$tmp_file" && mv "$tmp_file" "$TARGET_SETTINGS"
        echo "Added settings to your settings.json!"
    else
        cp "$SETTINGS_FILE" "$TARGET_SETTINGS"
        echo "settings.json not found, created new with new settings"
    fi
else
    echo "settings.json not found"
fi

echo ""
printf "\e[32m======================================\e[0m\n"
printf "\e[32m     SETTINGS HAVE BEEN UPDATED       \e[0m\n"
printf "\e[32m======================================\e[0m\n"
echo ""

CUSTOM_CSS_FILE="./qalqa-customcss.css"
if [ -f "$CUSTOM_CSS_FILE" ]; then
    cp "$CUSTOM_CSS_FILE" "$USER_SETTINGS_DIR/qalqa-customcss.css"
    echo "qalqa-customcss.css copied into $USER_SETTINGS_DIR!"
else
    echo "qalqa-customcss.css not found"
fi

echo "Running post-installation commands..."

if [[ "$OS_TYPE" == "Linux" ]]; then
    xdg-open "vscode://command/extension.installCustomCSS"
    xdg-open "vscode://command/VSCode-Animations.enableAnimations"
    xdg-open "vscode://command/extension.installVibrancy"
elif [[ "$OS_TYPE" == "Darwin" ]]; then
    open "vscode://command/extension.installCustomCSS"
    open "vscode://command/VSCode-Animations.enableAnimations"
    open "vscode://command/extension.installVibrancy"
elif [[ "$OS_TYPE" == "MINGW32_NT"* ]] || [[ "$OS_TYPE" == "MINGW64_NT"* ]] || [[ "$OS_TYPE" == "CYGWIN"* ]]; then
    start "" "vscode://command/extension.installCustomCSS"
    start "" "vscode://command/VSCode-Animations.enableAnimations"
    start "" "vscode://command/extension.installVibrancy"
else
    echo "Unknown operating system, skipping post-installation commands. Please run them manually. Check the README for more info"
fi

echo "Post-installation commands executed successfully!"

echo ""
printf "\e[32m======================================\e[0m\n"
printf "\e[32m        INSTALLATION COMPLETED        \e[0m\n"
printf "\e[32m======================================\e[0m\n"
