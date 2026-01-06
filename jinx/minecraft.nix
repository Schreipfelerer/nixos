{ config, ... }:
{
  sops.secrets."minecraft/CF_API_KEY" = { };
  virtualisation.oci-containers.containers."mc-startechnology" = {
    image = "itzg/minecraft-server:java17";
    ports = [ "25565:25565" ];
    volumes = [
      "/var/lib/minecraft/startechnology/data/:/data/"
    ];
    environment = {
      EULA = "TRUE";
      INIT_MEMORY = "4G";
      MAX_MEMORY = "8G";
      TYPE = "AUTO_CURSEFORGE";
      TZ = "CEST";
      MOTD = "Star";
      LEVEL_TYPE = "skyblockbuilder:skyblock";
      ALLOW_FLIGHT = "true";
      ENABLE_WHITELIST = "true";
      Whitelist = "Schreipfelerer";
      OPS = "Schreipfelerer";
      CF_SLUG = "star-technology";
    };
    environmentFiles = [
      config.sops.secrets."minecraft/CF_API_KEY".path
    ];
    # extraOptions = [
    #     "--tty"
    #     "--interactive"
    # ];
    autoStart = false;
  };
}
