{ config, pkgs, ... }:

{
  # Microbin
  services.microbin = {
    enable = true;
    settings = {
      MICROBIN_PORT = 8080;
      MICROBIN_PUBLIC_PATH = "http://bin.thabo.internal";
      MICROBIN_HIDE_LOGO = true;
      MICROBIN_HIDE_FOOTER = true;
      MICROBIN_ADMIN_USERNAME = false;

      MICROBIN_QR = true;
      MICROBIN_ETERNAL_PASTA = true;
      MICROBIN_ENABLE_BURN_AFTER = true;
      MICROBIN_PRIVATE = true;
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

  # Uptime Kuma
  services.uptime-kuma = {
    enable = true;
  };

  # Paperless
  services.paperless = {
    enable = true;
    port = 28981;
  };

  # Glances
  services.glances = {
    enable = true;
    port = 61208;
  };
}