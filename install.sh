#!/bin/bash

echo "╔═══════════════════════════════════════════════════════════════════════╗"
echo '║                                  /$$                                  ║'
echo '║                                 | $$                                  ║'
echo '║               /$$$$$$   /$$$$$$ | $$  /$$$$$$   /$$$$$$               ║'
echo '║              /$$__  $$ |____  $$| $$ /$$__  $$ |____  $$              ║'
echo '║             | $$  \ $$  /$$$$$$$| $$| $$  \ $$  /$$$$$$$              ║'
echo '║             | $$  | $$ /$$__  $$| $$| $$  | $$ /$$__  $$              ║'
echo '║             |  $$$$$$$|  $$$$$$$| $$|  $$$$$$$|  $$$$$$$              ║'
echo '║              \____  $$ \_______/|__/ \____  $$ \_______/              ║'
echo '║                   | $$                    | $$                        ║'
echo '║                   | $$                    | $$                        ║'
echo '║                   |__/                    |__/                        ║'
echo "╠═══════════════════════════════════════════════════════════════════════╣"
echo "║                WELCOME TO QALQA'S VSCODE SETUP SCRIPT                 ║"
echo "╚═══════════════════════════════════════════════════════════════════════╝"
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
printf "\e[32m══════════════════════════════════════════════\e[0m\n"
printf "\e[32m      ALL EXTENSIONS HAVE BEEN INSTALLED      \e[0m\n"
printf "\e[32m══════════════════════════════════════════════\e[0m\n"
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

SETTINGS_FILE="./src/settings/settings-ot.json"
TARGET_SETTINGS="$USER_SETTINGS_DIR/settings.json"

case "$OS_TYPE" in
"Linux" | "Darwin")
    EXTENSIONS_DIR="$HOME/.vscode/extensions"
    ;;
"MINGW32_NT"* | "MINGW64_NT"* | "CYGWIN"*)
    EXTENSIONS_DIR="${APPDATA:-$HOME/AppData/Roaming}/Code/User"
    ;;
*)
    echo "Unknown operating system, cannot generate paths automatically!"
    exit 1
    ;;
esac

VSCODE_ANIMATIONS_PATH="$EXTENSIONS_DIR/brandonkirbyson.vscode-animations-2.0.7/dist/updateHandler.js"
CUSTOM_CSS_PATH="$USER_SETTINGS_DIR/qalqa-customcss.css"

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

jq --arg animationsPath "file://$VSCODE_ANIMATIONS_PATH" \
    --arg customCssPath "file://$CUSTOM_CSS_PATH" \
    '. + { "vscode_custom_css.imports": [$animationsPath, $customCssPath] }' \
    "$TARGET_SETTINGS" >"$TARGET_SETTINGS.tmp" && mv "$TARGET_SETTINGS.tmp" "$TARGET_SETTINGS"

echo ""
printf "\e[32m══════════════════════════════════════════════\e[0m\n"
printf "\e[32m          SETTINGS HAVE BEEN UPDATED          \e[0m\n"
printf "\e[32m══════════════════════════════════════════════\e[0m\n"
echo ""

CUSTOM_CSS_FILE="./src/styles/qalqa-customcss.css"
if [ -f "$CUSTOM_CSS_FILE" ]; then
    cp "$CUSTOM_CSS_FILE" "$USER_SETTINGS_DIR/qalqa-customcss.css"
    echo "qalqa-customcss.css copied into $USER_SETTINGS_DIR!"
else
    echo "qalqa-customcss.css not found"
fi

echo ""
printf "\e[32m══════════════════════════════════════════════\e[0m\n"
printf "\e[32m            INSTALLATION COMPLETED            \e[0m\n"
printf "\e[32m══════════════════════════════════════════════\e[0m\n"
