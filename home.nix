{ config, pkgs, ... }:

{
  home.username = "thobui";
  home.homeDirectory = "/Users/thobui";
  home.stateVersion = "24.11";
  home.packages = [
    pkgs.nerd-fonts.iosevka
    pkgs.gh
    pkgs.neovim
    pkgs.lazygit
    pkgs.alacritty
    pkgs.tmux
    pkgs.fzf
    pkgs.eza
    pkgs.yabai
    pkgs.fnm
    pkgs.zoxide
    pkgs.zsh
    pkgs.fastfetch
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
};
  # Program configuration
  programs.gh.enable = true;

  # Enable home-manager to manage itself
  programs.home-manager.enable = true;
}

