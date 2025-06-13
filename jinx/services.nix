{ config, pkgs, ... }:

{
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

  # Factorio
  # services.factorio = {
  #   enable = true;
  #   port = 34197;
  #   openFirewall = true;
  #   game-name = "thabo";
  #   description = "Thabo's Factorio Server";
  #   admins = [ "Schreipfelerer" ];
  #   nonBlockingSaving = true;
  #   loadLatestSave = true;
  #   mods =
  #     let
  #       inherit (pkgs) lib;
  #       modDir = /var/lib/factorio/factorio-mods;
  #       modList = lib.pipe modDir [
  #         builtins.readDir
  #         (lib.filterAttrs (k: v: v == "regular"))
  #         (lib.mapAttrsToList (k: v: k))
  #         (builtins.filter (lib.hasSuffix ".zip"))
  #       ];
  #       modToDrv = modFileName:
  #         pkgs.runCommand "copy-factorio-mods" {} ''
  #           mkdir $out
  #           cp ${modDir + "/${modFileName}"} $out/${modFileName}
  #         ''
  #         // { deps = []; };
  #     in
  #       builtins.map modToDrv modList;
  # };
}
