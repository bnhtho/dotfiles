{ config, pkgs, ... }:

{
  home.username = "thobui";
  home.homeDirectory = "/Users/thobui";
  home.stateVersion = "24.11";
  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.gh
    pkgs.neovim
    pkgs.lazygit
    pkgs.alacritty
    pkgs.fzf
    pkgs.eza
    pkgs.yabai
    pkgs.fnm
    pkgs.zoxide
    pkgs.zsh
    pkgs.fastfetch
    pkgs.btop
    pkgs.skhd
    ## -- Text other ---
    pkgs.obsidian
    pkgs.skhd
    pkgs.tmux
  ];
 programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
programs.zsh = {
enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
};
## - Tmux 
programs.tmux = {
	enable = true;
	terminal = "screen-256color";

};
 # Symlink configuration for Alacritty
home.file.".zshrc" = {
  source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/zsh/.zshrc";
};
  xdg.configFile = {
    "alacritty" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/alacritty";
      recursive = true;
    };
"zsh" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/zsh";
      recursive = true;
    };
    ## Yabai: Windows Manager
"yabai" = {
source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/yabai";
      recursive = true;
};

"skhd" = {
source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/skhd";
      recursive = true;
};

## End of symlink

};
  # Program configuration
  programs.gh.enable = true;
 # Program fzf-zsh enabled
 programs.fzf = {
	enable = true;
	enableZshIntegration = true;
 };
  # Enable home-manager to manage itself
  programs.home-manager.enable = true;
 nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };
}

