# qalqa's VSCode Minimalism Rework

A custom theme that reimagines Visual Studio Code’s layout—adding transparency, animations, and a minimalistic aesthetic that’s a breath of fresh air compared to the default interface. Currently in deep beta, so expect a few quirks along the way.

---

## Description

This theme completely reworks VSCode's layout with added transparency and smooth animations, giving your editor a modern and elegant look. It’s designed for those who appreciate minimalism and a touch of style in their development environment.

---

## Installation Guide

> **Important:**  
> The transparency effect is only available in the outdated VSCode version (v1.95.3) due to limitations in newer Electron releases. If you’re using a later version, proceed at your own risk or disable transparency in the installer.

### 1. Install Outdated VSCode

Download and install the legacy version:  
[VSCode 1.95.3](https://drive.google.com/file/d/1ED8tpUxnub-BNxfodq2fmRKtk3cPZAQ7/view?usp=drive_link)

### 2. Disable Automatic Updates

Prevent VSCode from updating by adding the following to your `settings.json`:

```json
"update.mode": "none"
```

### 3. Platform-Specific Steps

#### MacOS/Linux

Claim ownership of the VSCode installation directory by running:

```shell
sudo chown -R $(whoami) "$(which code)"
sudo chown -R $(whoami) /usr/share/code
```

#### Windows

Make sure to run Visual Studio Code in **Administrator** mode before enabling or disabling your custom style.

### 4. Run the Installer

Execute the installer script:

- `install.sh` or `install_full.sh`

  Choose based on how closely you want to replicate my configuration.

### 5. Follow the Installer Guide

Proceed through the instructions provided by the installer.

### 6. Finalize Setup

- Restart VSCode.
- Open the Command Palette:
  - MacOS: `Cmd` + `Shift` + `P`
  - Linux/Windows: `Ctrl` + `Shift` + `P`
- Run the following commands one by one:
  - Enable Custom CSS and JS
  - Enable Animations
  - Enable Vibrancy
  - Restart VSCode again.

### 7. Enjoy!

Sit back and enjoy your beautifully revamped VSCode experience. 👀

## Screenshots

Empty Workspace

![dark-empty](./src/assets/image-4.png)

Main view

![dark](./src/assets/image.png)

Quick menu

![dark-quick-menu](./src/assets/image-1.png)

Search Interface

![dark-search](./src/assets/image-2.png)

Light Theme (In Development)

![light](./src/assets/image-3.png)

## Used extensions

1.  [Vibrancy Continued](https://marketplace.visualstudio.com/items?itemName=illixion.vscode-vibrancy-continued)
2.  [Catppuccin Theme](https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc)
3.  [Catppuccin Icons](https://marketplace.visualstudio.com/items?itemName=Catppuccin.catppuccin-vsc-icons)
4.  [VSCode Animations](https://marketplace.visualstudio.com/items?itemName=BrandonKirbyson.vscode-animations)
5.  [Custom Css and JS](https://marketplace.visualstudio.com/items?itemName=be5invis.vscode-custom-css)
