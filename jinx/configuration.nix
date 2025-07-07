# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./arr.nix
      ./services.nix
    ];
  
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  
  sops.defaultSopsFile = ../secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/user/.config/sops/age/keys.txt";

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
     sops
     btop
     dig
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.LogLevel = "VERBOSE";
  };

  # Protect SSH with fail2ban
  services.fail2ban = {
    enable = true;
  };

  # Homepage
  services.homepage-dashboard = {
    enable = true;
    allowedHosts = "thabo.internal";
    settings = {
      layout = [
        {
          "7 Seas" = {
            header = true;
            style = "column";
          };
        }
        {
          "Services" = {
            header = true;
            style = "column";
          };
        }
      ];
    };
    widgets = [
      {
        glances = {
          url = "http://glances.thabo.internal";
          version = 4;
          cpu = true;
          mem = true;
          cputemp = true;
          uptime = true;
          disk = "/";
        };
      }
      {
        datetime = {
          text_size = "xl";
          format = {
            timeStyle = "short";
            hourCycle = "h23";
          };
        };
      }
    ];
    services = [
      {
        "7 Seas" = [
          {
          }
        ];
      }
      {
        "Services" = [
          {
            "Paperless" = {
              href = "http://paperless.thabo.internal";
              description = "Document Management System";
              icon = "paperless.png";
            };
          }
          {
            "Microbin" = {
              href = "https://bin.thabo.dev";
              description = "Pastebin/Code Snippet Sharing";
              icon = "microbin.png";
            };
          }
          {
            "Vaultwarden" = {
              href = "http://vault.thabo.internal";
              description = "Password Manager";
              icon = "vaultwarden.png";
            };
          }
          {
            "AdGuardHome" = {
              href = "http://dns.thabo.internal";
              description = "Network-wide Ad & Tracker Blocking";
              icon = "adguard-home.png";
            };
          }
          {
            "Nextcloud" = {
              href = "https://cloud.thabo.dev";
              description = "Personal Cloud Storage";
              icon = "nextcloud.png";
            };
          }
          {
            "Uptime Kuma" = {
              href = "http://status.thabo.internal";
              description = "Self-hosted Status Monitoring";
              icon = "uptime-kuma.png";
            };
          }
        ];
      }
    ];
  };

  users.users.nginx.extraGroups = [ "acme" ];
  # Nginx
  services.nginx = {
    enable = true;
    #recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts = {
      "cloud.thabo.dev" = {
        useACMEHost = "thabo.dev";
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://localhost:8088";
        };
      };
      "bin.thabo.dev" = {
        useACMEHost = "thabo.dev";
        forceSSL = true;
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
      "glances.thabo.internal" = {
        locations."/" = {
          proxyPass = "http://localhost:61208";
        };
      };
      "status.thabo.internal" = {
        locations."/" = {
          proxyPass = "http://localhost:3001";
        };
      };
      "thabo.internal" = {
        locations."/" = {
          proxyPass = "http://localhost:8082";
        };
      };
      "wildcart.thabo.dev" = {
        useACMEHost = "thabo.dev";
        forceSSL = true;
        serverAliases = [ "*.thabo.dev" ];
        locations."/" = {
          return = 404;
        };
      };
    };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "you@thabo.dev";
    certs."thabo.dev" = {
      extraDomainNames = [ "*.thabo.dev" ];
      dnsProvider = "hetzner";
      environmentFile = "/var/lib/acme/hetzner.env";
    };
  };

  # Firewall
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 53 80 443 ];
    allowedUDPPorts = [ 53 ];
  };

  # Filesystem
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" ];
    "/var/lib".options = [ "compress=zstd" "noatime" ];
    "/swap".options = [ "noatime" ];
  };
  
  # Swap
  swapDevices = [ { device = "/swap/swapfile"; } ];

  # Nix flakes
  nix.settings.experimental-features = [
    "nix-command" 
    "flakes"
  ];

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
