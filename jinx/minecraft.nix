{ config, ...}:
{
    sops.secrets."minecraft/CF_API_KEY" = {};
    virtualisation.oci-containers.containers."mc-startechnology" = {
        image = "itzg/minecraft-server:java17";
        ports = ["25565:25565"];
        volumes = [
            "var/lib/minecraft/startechnology/data/:/data/"
        ];
        enviroment = {
            EULA = "TRUE";
            INIT_MEMORY = "4G";
            MAX_MEMORY = "8G";
            TZ = "CEST";
            MOTD = "Star";
            ENABLE_WHITELIST = "true";
            Whitelist = "Schreipfelerer";
            CF_API_KEY = "";
            CF_SLUG = "star-technology";
        };
        environmentFiles = [
          config.sops.secrets."minecraft/CF_API_KEY".path
        ];
        extraOptions = [
            "--tty"
            "--interactive"
        ];
        autoStart = false;
    };
}
