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
# -- config terminal
enable = true;
initExtra = ''
       if [[ $(ps -o command= -p "$PPID" | awk '{print $1}') != 'fish' ]]
      then
          exec fish -l
      fi                       '';

};
programs.fish = {
	enable = true;
	#-- plugins of fish
	interactiveShellInit = ''
	# Add fnm shell-fish env
	fnm env --use-on-cd --shell fish | source
	# Add zoxide shell-fish env
        zoxide init fish | source
	'';
};
# -- Zoxide
programs.zoxide={
enable = true;
enableFishIntegration= true;
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
