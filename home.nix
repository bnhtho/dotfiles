{ config, pkgs, ... }: 

{
  # Basic configuration
  home.username = "thobui";
  home.homeDirectory = "/Users/thobui";
  home.stateVersion = "24.11";
# Overriding Multipass source with specific version
  nixpkgs.overlays = [
    (self: super: {
      multipass = super.multipass.overrideAttrs (old: {
        version = "1.14.1";
        src = pkgs.fetchFromGitHub {
          owner = "canonical";
          repo = "multipass";
          rev = "v1.14.1";
          sha256 = "07yxvbh1fk8mwsqm62mfjwpr4p65msrqgnw3v8l6ibj8axgqx0ry";
        };
      });
    })
  ];  # Packages
  home.packages = [
    # Fonts
    pkgs.nerd-fonts.jetbrains-mono

    # Development tools
    pkgs.neovim
    pkgs.lazygit
    pkgs.gh
    pkgs.fnm
    pkgs.zsh
    pkgs.alacritty

    # Productivity tools
    pkgs.obsidian
    pkgs.tmux

    # Utilities
    pkgs.fzf
    pkgs.eza
    pkgs.ripgrep
    pkgs.fd
    pkgs.fastfetch
    pkgs.btop
    pkgs.zoxide
    pkgs.yabai
    pkgs.skhd

    # Multipass
    pkgs.multipass

 ];

  # Programs configuration
  programs = {
    # Zoxide
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    # Zsh
    zsh = {
      enable = true;
    };

    # Tmux
    tmux = {
      enable = true;
      terminal = "screen-256color";
    };

    # fzf
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    # GitHub CLI
    gh.enable = true;

    # Home-manager self-management
    home-manager.enable = true;
  };

  # Symlink configurations
  xdg.configFile = {
    # Alacritty
    "alacritty" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/alacritty";
      recursive = true;
    };

    # Yabai
    "yabai" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/yabai";
      recursive = true;
    };

    # Neovim
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/nvim";
      recursive = true;
    };

    # skhd
    "skhd" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/skhd";
      recursive = true;
    };
  };

  # Zsh configuration file
  home.file.".zshrc" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/zsh/.zshrc";
  };

  # Nixpkgs configuration
  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
    allowUnfreePredicate = (_: true);
    allowBroken = true;
  };
}

