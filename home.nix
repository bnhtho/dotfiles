{ config, pkgs, ... }: 

{
  # Basic configuration
  home.username = "thobui";
  home.homeDirectory = "/Users/thobui";
  home.stateVersion = "24.11";
# Overriding Multipass source with specific version
 ## List packages
 home.packages = [
    # Fonts
    pkgs.nerd-fonts.jetbrains-mono

    # Development tools
    pkgs.neovim
    pkgs.git
    pkgs.lazygit
    pkgs.gh
    pkgs.fnm
    pkgs.zsh
    pkgs.alacritty
    pkgs.vscode
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
    pkgs.keka
    ];

  # Programs configuration
  programs = {
    # Git
    git = {
      enable = true;
      userName = "Bùi Nguyễn Hoàng Thọ";
      userEmail = "thohnb@gmail.com";
      extraConfig = {
        color.ui = "auto";
        merge.tool = "meld";
        core.editor = "neovim";
        core.excludesfile = "~/.gitignore";
      };
    };
    # Zoxide
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    vscode = {
      enable = true;
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

