# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./wireguard.nix
  ];

  stylix.enable = true;
  stylix.autoEnable = false;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-medium.yaml";

  sops.defaultSopsFile = ../secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/bo/.config/sops/age/keys.txt";

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
      timeout = 0; # You can still press a key
    };
    # Early Systemd
    initrd.systemd.enable = true;
    #initrd.kernelModules = [ "i915" ];

    # Secure Boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      #settings.consoleMode = "max";
    };

    # Fancy Animation :D
    plymouth =
      let
        theme = "rings"; # https://github.com/adi1090x/plymouth-themes
      in
      {
        enable = true;
        inherit theme;
        themePackages = [ (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ theme ]; }) ];
      };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
  };

  security.tpm2.enable = true;
  security.tpm2.pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
  security.tpm2.tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
  security.pam.services = {
    hyprlock = {
    }; # PAM for Hyprlock
  };

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  networking.hostName = "ekko";

  # Power Actions
  services.logind.settings.Login = {
    HandlePowerKey = "hibernate";
    HandlePowerKeyLongPress = "poweroff";
    HandlelLdSwitch = "suspend-then-hibernate";
  };
  systemd.sleep.extraConfig = "HibernateDelaySec=30m";

  # Fingerprint Reader
  services.fprintd.enable = false;

  # Set your time zone.
  time.timeZone = lib.mkDefault "Europe/Berlin";
  services.automatic-timezoned.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    earlySetup = true;
    font = null;
    keyMap = "de";
  };
  i18n.extraLocaleSettings = {
    LC_TIME = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
  };

  # Set Homemanager vars
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.bo = home/home.nix;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };
  services.jack.jackd.enable = false;

  # Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = [
      pkgs.noto-fonts
      pkgs.noto-fonts-cjk-sans
      pkgs.noto-fonts-color-emoji
      pkgs.nerd-fonts.symbols-only
      pkgs.nerd-fonts.jetbrains-mono
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" ];
        monospace = [ "JetBrains Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bo = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Sudo
      "networkmanager" # Networking
      "tss" # Serial
      "dialout" # Serial
      "uucp" # Serial
      "plugdev" # Usb
      "wireshark" # Wireshark
      "audio" # audio
    ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd}/bin/agreety --cmd  hyprland";
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable fwupd for Bios Updates
  services.fwupd.enable = true;

  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  # Nix flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  swapDevices = [ { device = "/swap/swapfile"; } ];

  # Filesystem
  fileSystems = {
    "/".options = [ "compress=zstd noatime" ];
    "/nix".options = [ "compress=zstd noatime" ];
    "/home".options = [ "compress=zstd" ];
    "/var/log".options = [
      "compress=zstd"
      "noatime"
    ];
    "/swap".options = [ "noatime" ];
  };

  # Environment Vars
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  # Programms
  environment.systemPackages = with pkgs; [
    busybox
    networkmanagerapplet
    playerctl
    swaynotificationcenter
    libnotify
    hyprpolkitagent
    hyprlock
    brightnessctl
    btop
    wl-clipboard
    ulauncher
    grim
    slurp
    swappy
    dig
    cloc
    stress
    nss
    signal-desktop
    libreoffice
    speedtest-cli
    filezilla
    sops
    sonic-pi
    pipewire.jack
  ];

  programs.pulseview.enable = true; # Sigrok
  programs.steam.enable = true; # Steam
  programs.wireshark.enable = true;

  programs.nh = {
    enable = true;
    flake = "/etc/nixos";
  };

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Desktop Portal
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Delete old generatrions
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Power Managment
  services.tlp.enable = false;
  services.power-profiles-daemon.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
