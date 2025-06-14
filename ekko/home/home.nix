# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {

  imports = [
    ./shell.nix
    ./waybar.nix
    ./hypr.nix
  ]; 

  # wayland.windowManager.hyprland.enable = true;


  home.username = "bo";
  home.homeDirectory = "/home/bo";
  home.packages = with pkgs; [
    thunderbird
    firefox
    nautilus
    discord
    gimp3
    spotify
    steam
    blender
    superTux
    vlc
    prismlauncher
    godot
  ];
  
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      ripgrep
      gcc
      libgcc
      stylua
    ];
  };

  programs.git = {
    enable = true;
    userName = "Schreipfelerer";
    userEmail = "Schreipfelerer@gmail.com";
    delta.enable = false;
    extraConfig = {
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.kitty = {
    enable = true;
  };

  # Stylix
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";
    
    targets = {
      btop.enable = true;
      gtk.enable = true;
      kitty.enable = true;
      qt.enable = true;
      fish.enable = true;
      waybar.enable = true;
      waybar.addCss = false; 
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };


  home.stateVersion = "25.05";
}
