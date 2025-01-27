My dotfiles
## Notes
### Setup xcode installer
```bash
xcode-select --install
```
### Git Clone .dotfiles 
```bash
# Git clone dotfiles to $HOME/.dotfiles
git clone https://github.com/bnhtho/dotfiles ~/.dotfiles
# Move to .dotfiles
cd ~/.dotfiles
## Running script to setup dotfiles
sh setup.sh
## NOTE: some steps required password to execute as root.
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
### Multipass (Ubuntu VM)
```bash
curl -ls https://raw.githubusercontent.com/bnhtho/dotfiles/67753bb6bf33adf07468cc3a438937843c2b278b/multipass.sh | bash
```
If facing error "No instance found", turn off terminal and run the script again