# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "jinx"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "de";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.bo = {
    isNormalUser = true;
    description = "bo";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM5ZEWaWRUWk1LXyoDdZoLSIdiOxP3JmzNvMR89/sXd1 schreipfelerer@gmail.com"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     git
     fastfetch
     btop
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
  };
  
  # Paperless
  services.paperless = {
    enable = true;
    port = 28981;
  };

   # Homepage
  services.homepage-dashboard = {
    enable = true;
    allowedHosts = "home.thabo.dev,thabo.internal";
    settings = {
	title = "thabo.internal";
    };
    services = [
       {
         "7 Seas" = [];
       }
       {
         "Services" = [
           {
           "Paperless" = {
           href = "http://paperless.thabo.internal"; # Nginx proxies to http://localhost:8000
           description = "Document Management System";
           icon = "paperless.png"; # Assuming you have an icon for Paperless in your homepage-dashboard config
         };
       }
       {
         "Microbin" = {
           href = "http://bin.thabo.internal"; # Nginx proxies to http://localhost:8080
           description = "Pastebin/Code Snippet Sharing";
           icon = "microbin.png"; # Assuming you have an icon for Microbin
         };
       }
       {
         "Vaultwarden" = {
           href = "http://vault.thabo.internal"; # Nginx proxies to http://localhost:8222
           description = "Password Manager";
           icon = "vaultwarden.png"; # Assuming you have an icon for Vaultwarden
         };
       }
       {
         "AdGuardHome" = {
           href = "http://dns.thabo.internal"; # Nginx proxies to http://localhost:3000
           description = "Network-wide Ad & Tracker Blocking";
           icon = "adguard.png"; # Assuming you have an icon for AdGuard Home
         };
       }
       {
         "Nextcloud" = {
           href = "http://cloud.thabo.internal"; # Nginx proxies to http://localhost:8088
           description = "Personal Cloud Storage";
           icon = "nextcloud.png";
         };
       }

	 ];
       }
    ];
  };
 
  # Paperless
  services.microbin = {
    enable = true;
    settings = {
      MICROBIN_PORT = 8080;
      MICROBIN_HIDE_LOGO = true;
      MICROBIN_HIDE_FOOTER = true;
      MICROBIN_QR = true;
      MICROBIN_PUBLIC_PATH = "http://bin.thabo.internal";
      MICROBIN_ETERNAL_PASTA = true;
      MICROBIN_ADMIN_USERNAME = false;
      MICROBIN_ENABLE_BURN_AFTER = true;
      MICROBIN_ENABLE_READONLY = true;
      MICROBIN_ENCRYPTION_HASH_IDS = true;
      MICROBIN_PRIVATE = true;
      MICROBIN_SHORT_PATH = "http://bin.thabo.internal";
    };
  };

  # Nextcloud
  services.nextcloud = {
    enable = false;
    hostName = "cloud.thabo.dev";
  };
  
  # Vaultwarden
  services.vaultwarden = {
    enable = true;
  };

  # Adguard
  services.adguardhome = {
    enable = true;
  };

  # Nginx
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "cloud.thabo.internal" = {
        locations."/" = {
          proxyPass = "http://localhost:8088";
        };
      };
      "bin.thabo.internal" = {
        locations."/" = {
          proxyPass = "http://localhost:8080";
        };
      };
      "dns.thabo.internal" = {
        locations."/" = {
          proxyPass = "http://localhost:3000";
        };
      };
      "vault.thabo.internal" = {
        locations."/" = {
          proxyPass = "http://localhost:8222";
        };
      };
      "paperless.thabo.internal" = {
        locations."/" = {
          proxyPass = "http://localhost:28981";
        };
      };
      "thabo.internal" = {
        locations."/" = {
          proxyPass = "http://localhost:8082";
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "me@thabo.dev";
  };

  networking.firewall.allowedTCPPorts = [ 53 80 443 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  # Filesystem
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" ];
    "/var/lib".options = [ "compress=zstd" "noatime" ];
    "/swap".options = [ "noatime" ];
  };
  
  # Swap
  swapDevices = [ { device = "/swap/swapfile"; } ];

  # Delete old generatrions
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
