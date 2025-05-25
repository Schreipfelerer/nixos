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
    thunderbird
    firefox
    nautilus
    discord
    gimp3
    spotify
    steam
    nodejs_24
    corepack_24
    blender
    superTux
    vlc
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

  programs.zoxide = {
    enable = true;
  };

  programs.fastfetch = {
    enable = true;
  };



  # Stylix
  stylix.enable = true;
  stylix.autoEnable = false;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";

  home.stateVersion = "25.05";
}
