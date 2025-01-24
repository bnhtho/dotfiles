## Instruction

Install xcode
```bash
xcode-select --install
```
### Install Nix
```bash
    curl -L https://nixos.org/nix/install | sh
```
### Add channel
```bash
    echo "Adding Home Manager channel..."
    nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
    nix-channel --update
    echo "Home Manager channel added successfully."
```

Run the script to install `.dotfile` for both Linux and MacOS
```bash
curl -ls https://raw.githubusercontent.com/bnhtho/dotfiles/refs/heads/main/setup.sh | bash
```
Restart shell

## Install Multipass (Linux)
Execute `ubuntu.sh` file

```bash
```
## Suggestion
Install hyperkey app here to bind `CapsLock` to `Alt(Option)`
```bash
https://hyperkey.app/
```

## TODO
- Fix bugs 
- Improve the dotfiles 
- Delete unused config