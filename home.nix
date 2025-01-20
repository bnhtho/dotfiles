{ config, pkgs, ... }:

{
  home.username = "__USERNAME__"; # Placeholder for username
  home.homeDirectory = "__HOMEDIR__"; # Placeholder for home directory
  home.stateVersion = "24.11"; 
  home.packages = [
    pkgs.nerd-fonts.iosevka
    pkgs.gh
    pkgs.neovim
    pkgs.lazygit
    pkgs.fish
    pkgs.alacritty
    pkgs.tmux
    pkgs.fzf
    pkgs.eza
    pkgs.yabai
    pkgs.fnm
    pkgs.zoxide
  ];

  programs.zsh = {
    enable = true;
    initExtra = ''
      if [[ $(ps -o command= -p "$PPID" | awk '{print $1}') != 'fish' ]]
      then
          exec fish -l
      fi
    '';
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      # Disable greetings line
      set -g fish_greeting
      # Add fnm shell-fish env
      fnm env --use-on-cd --shell fish | source
      # Add zoxide shell-fish env
      zoxide init fish | source
    '';
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # Symlink configuration for Alacritty
  xdg.configFile = {
    "alacritty" = {
      source = config.lib.file.mkOutOfStoreSymlink "__HOMEDIR__/config/alacritty";
      recursive = true;
    };
  };

  # Program configuration
  programs.gh.enable = true;

  # Enable home-manager to manage itself
  programs.home-manager.enable = true;
}
