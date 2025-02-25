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
echo "======================================"
echo "  ALL EXTENSIONS HAVE BEEN INSTALLED  "
echo "======================================"
