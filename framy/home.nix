# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  home.username = "bo";
  home.homeDirectory = "/home/bo";
  home.packages = with pkgs; [
    btop
    wl-clipboard
    ulauncher
  ];
  
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
  };

  programs.git = {
    enable = true;
    userName = "Schreipfelerer";
    userEmail = "Schreipfelerer@gmail.com";
    extraConfig = {
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.firefox = {
    enable = true;
  };

  programs.kitty = {
    enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = builtins.readFile ./hyprland.conf;
  };

  programs.waybar = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
  };

  programs.fastfetch = {
    enable = true;
  };

  home.stateVersion = "25.05";
}
