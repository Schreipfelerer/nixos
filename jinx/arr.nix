{ config, pkgs, ... }:

{
  users.groups.media = { };

  services.jellyfin.enable = true;
  services.jellyfin.group = "media";

  services.sonarr.enable = true;
  services.sonarr.group = "media";

  services.radarr.enable = true;
  services.radarr.group = "media";

  services.jellyseerr.enable = true;

  services.bazarr.enable = true;
  services.bazarr.group = "media";

  services.prowlarr.enable = true;

  services.sabnzbd.enable = true;
  services.sabnzbd.group = "media";

  # Transmission
}

