{ config, pkgs, ... }:

{
  imports = [
    ./authentik.nix
  ];

  # Microbin
  services.microbin = {
    enable = true;
    settings = {
      MICROBIN_PORT = 8080;
      MICROBIN_PUBLIC_PATH = "https://bin.thabo.dev";
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
    config = {
      adminpassFile = "/var/lib/nextcloud/admin-password";
      dbtype = "pgsql";
    };
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
    settings = {
      PAPERLESS_OCR_LANGUAGE = "deu+eng";
      PAPERLESS_OCR_USER_ARGS = {
        optimize = 1;
        pdfa_image_compression = "lossless";
      };
      PAPERLESS_URL = "https://paperless.thabo.dev";

      PAPERLESS_DISABLE_REGULAR_LOGIN = true;
      PAPERLESS_REDIRECTS_LOGIN_TO_SSO = true;
      PAPERLESS_SOCIAL_AUTO_SIGNUP = true;

      PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect"; 
    };
    environmentFile = config.sops.secrets."paperless/environment".path;
  };
  sops.secrets."paperless/environment" = {};

  # Glances
  services.glances = {
    enable = true;
    port = 61208;
  };

}
