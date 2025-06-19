#!/bin/bash

# Script to install environment for helm-demo project

echo "🚀 Starting environment setup for helm-demo..."

# --- Prerequisites Check (Informational) ---
echo "ℹ️ Please ensure you have a Linux environment (Ubuntu/Debian recommended) with sudo privileges."
echo "ℹ️ Required package managers: apt, curl, wget."
echo "--------------------------------------------------"
sleep 2

# --- 3. Install Neovim (Optional) ---
read -p "🔧 Do you want to install Neovim and configure LazyVim? (y/N): " install_neovim
if [[ "$install_neovim" =~ ^[Yy]$ ]]; then
    echo "⚙️ Installing Neovim..."
    if command -v nvim &> /dev/null && [[ $(nvim --version | head -n 1) == *"NVIM v0.9."* || $(nvim --version | head -n 1) == *"NVIM v0.1"* ]]; then # crude check for recent enough version
        echo "✅ Neovim seems to be already installed and might be a recent version."
        nvim --version | head -n 1
    else
        curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
        sudo rm -rf /opt/nvim
        sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
        rm nvim-linux-x86_64.tar.gz
        echo "✅ Neovim downloaded and extracted to /opt/nvim-linux-x86_64"
        echo "📢 To use this Neovim version, add it to your PATH:"
        echo '   export PATH="$PATH:/opt/nvim-linux-x86_64/bin"'
        echo "   Consider adding this line to your ~/.bashrc or ~/.zshrc"
        # Attempt to add to .bashrc if it exists and not already there
        if [ -f ~/.bashrc ] && ! grep -q 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' ~/.bashrc; then
            echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
            echo "✅ Added Neovim to PATH in ~/.bashrc. Please source it or open a new terminal."
        fi
    fi

    echo "⚙️ Configuring LazyVim..."
    if [ -d ~/.config/nvim ]; then
        read -p "⚠️ ~/.config/nvim already exists. Do you want to remove it and clone LazyVim starter? (y/N): " replace_nvim_config
        if [[ "$replace_nvim_config" =~ ^[Yy]$ ]]; then
            rm -rf ~/.config/nvim
            git clone https://github.com/LazyVim/starter ~/.config/nvim
            echo "✅ LazyVim starter cloned to ~/.config/nvim."
        else
            echo "⏩ Skipping LazyVim configuration."
        fi
    else
        git clone https://github.com/LazyVim/starter ~/.config/nvim
        echo "✅ LazyVim starter cloned to ~/.config/nvim."
    fi
else
    echo "⏩ Skipping Neovim and LazyVim setup."
fi
echo "--------------------------------------------------"
sleep 1

# --- 4. Clone Repository ---
echo "📦 Cloning the helm-demo repository..."
if [ -d "helm-demo" ]; then
    echo "✅ 'helm-demo' directory already exists. Skipping clone."
else
    git clone https://github.com/jyasuu/helm-demo.git
    if [ $? -eq 0 ]; then
        echo "✅ Repository cloned successfully into 'helm-demo'."
        # cd helm-demo # Optionally cd into the directory
    else
        echo "❌ Error cloning repository. Please check the output above."
        exit 1
    fi
fi
echo "--------------------------------------------------"

echo "🎉 Environment setup script finished!"
echo "Next steps:"
echo "1. If Neovim was installed/updated, ensure /opt/nvim-linux-x86_64/bin is in your PATH (you might need to source your .bashrc/.zshrc or open a new terminal)."
echo "2. Navigate to the repository: cd helm-demo"
echo "3. Refer to the README.md for deployment instructions."
