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
    (ulauncher.override { webkitgtk_4_1 = webkitgtk_4_0; })
    thunderbird
    firefox
    nautilus
    discord
    gimp3
    waybar
    hyprland
    hypridle
    hyprpaper
    hyprlock
    brightnessctl
    swaynotificationcenter
    spotify
    steam
    playerctl
    nodejs_24
    corepack_24
  ];
  
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      ripgrep
    ];
  };

  programs.git = {
    enable = true;
    userName = "Schreipfelerer";
    userEmail = "Schreipfelerer@gmail.com";
    delta.enable = true;
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
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-soft.yaml";
  stylix.targets.neovim.enable = false;

  home.stateVersion = "25.05";
}
