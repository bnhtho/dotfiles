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
    pkgs.fishPlugins.tide
    # --- Fast
  ];

  

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Symlink configuration for Alacritty
  xdg.configFile = {
    "alacritty" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/alacritty";
      recursive = true;
    };
  };

  # Program configuration
  programs.gh.enable = true;

  # Enable home-manager to manage itself
  programs.home-manager.enable = true;
}

