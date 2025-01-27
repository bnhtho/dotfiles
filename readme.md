My dotfiles
## Notes
### - Setup xcode installer
```bash
xcode-select --install
```

### 2 - Running script 
```
curl -ls https://raw.githubusercontent.com/bnhtho/dotfiles/refs/heads/main/setup.sh | bash
```

### Activate Yabai + SKHD
```bash
yabai --start-service
skhd --start-service
```

### Install node lts version by command:
```bash
nvm install --lts
```

### Install Emmets 
```bash
npm i -g @olrtg/emmet-language-server
```

### Disable hold to popup accent
```bash
defaults write -g ApplePressAndHoldEnabled -bool false
```

### Make Dock smaller
```bash
defaults write com.apple.dock tilesize -int 36; killall Dock
```
