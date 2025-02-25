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
            [Yy] ) 
                printf "\e[32m✓\e[0m\n"
                optional_extensions+=("$extension_id")
                break
                ;;
            [Nn] ) 
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

echo "Используете ли вы стандартное расположение настроек VSCode? (Y/N): "
read -n1 -s std_answer
echo
if [[ $std_answer =~ [Yy] ]]; then
    echo "Choose your OS:"
    echo "1) Windows"
    echo "2) Linux (careful!)"
    echo "3) MacOS"
    while true; do
        echo -n "(1/2/3): "
        read -n1 -s os_choice
        echo "$os_choice"
        if [[ "$os_choice" == "1" || "$os_choice" == "2" || "$os_choice" == "3" ]]; then
            break
        else
            echo "Неверный выбор. Пожалуйста, попробуйте снова."
        fi
    done
    case "$os_choice" in
        1) 
            USER_SETTINGS_DIR="${APPDATA:-$HOME/AppData/Roaming}/Code/User"
            ;;
        2) 
            USER_SETTINGS_DIR="$HOME/.config/Code/User"
            ;;
        3) 
            USER_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
            ;;
    esac
else
    read -p "Введите полный путь к папке настроек VSCode: " USER_SETTINGS_DIR
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
               $user + $diff' "$SETTINGS_FILE" "$TARGET_SETTINGS" > "$tmp_file" && mv "$tmp_file" "$TARGET_SETTINGS"
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
printf "\e[32m        INSTALLATION COMPLETED        \e[0m\n"
printf "\e[32m======================================\e[0m\n"

