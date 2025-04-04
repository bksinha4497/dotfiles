#!/bin/bash

# Function to install a package using brew and check if it's already installed
install_brew_packages() {
  for package in "$@"; do
    if ! brew list "$package" &>/dev/null; then
      echo "Installing $package..."
    else
      echo "$package is already installed."
    fi
  done

  brew install "$@"
}

# Install fonts
echo "Tapping homebrew/cask-fonts for font installation..."
brew tap homebrew/cask-fonts

# Install necessary packages (combine into one install command)
echo "Installing fonts and software..."
install_brew_packages "font-hack-nerd-font" "font-sf-pro" \
                      "sketchybar" "raycast" "aerospace" "borders" \
                      "lazygit" "jq" "fzf" "btop" "bat" "nvim"

# Install Poimanderes color scheme for iTerm2
echo "Installing Poimanderes color scheme for iTerm2..."

# Download and install Poimanderes color scheme
POIMANDERES_URL="https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Poimanderes.itermcolors"
curl -Lo ~/Poimanderes.itermcolors "$POIMANDERES_URL"

# Apply Poimanderes color scheme to iTerm2
osascript <<EOF
tell application "iTerm"
    set thePrefs to preferences
    tell thePrefs
        set theProfiles to profiles
        repeat with thisProfile in theProfiles
            if name of thisProfile is equal to "Default" then
                set color preset of thisProfile to "~/Poimanderes.itermcolors"
            end if
        end repeat
    end tell
end tell
EOF

echo "Poimanderes color scheme has been applied to iTerm2."

# Clean up: Remove the downloaded color scheme file
rm ~/Poimanderes.itermcolors

# Install Oh My Zsh if not already installed
echo "Installing Oh My Zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh is already installed."
fi

# Install Powerlevel10k (Zsh theme)
echo "Installing Powerlevel10k..."

# Clone Powerlevel10k into the Zsh custom themes directory
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# Install zplug if not already installed (Zsh plugin manager)
echo "Installing zplug..."

if [ ! -d "$HOME/.zplug" ]; then
  curl -sL zplug.sh/installer | zsh
fi

# Add necessary plugins to .zshrc
echo "Configuring .zshrc with Powerlevel10k and plugins..."

cat >> ~/.zshrc <<EOF

# Enable Powerlevel10k theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable zplug plugin manager
source ~/.zplug/init.zsh

# Install plugins via zplug
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "you-should-use/zsh-you-should-use"
zplug "virtualenv/virtualenvwrapper"

# Load zplug plugins
zplug load --verbose

EOF

# Install zsh plugins
zplug install

# Start services
echo "Starting necessary services..."

# Start Aerospace
brew services start aerospace

# Start SketchyBar
brew services start sketchybar

# Start Borders
brew services start borders

# Done!
echo "All installations, configurations, and services are complete."

