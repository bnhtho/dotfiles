{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "thobui";
  home.homeDirectory = "/Users/thobui";
  home.stateVersion = "24.11"; # Please read the comment before changing.
  
  home.packages = [
    ## Install Nerd Fonts
    pkgs.nerd-fonts.iosevka
## --- Terminal ----------
  pkgs.gh
  pkgs.neovim
  pkgs.lazygit
  pkgs.fish
  pkgs.alacritty
  pkgs.tmux
  ];

  

  ## Program config
  programs.gh.enable = true;
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
