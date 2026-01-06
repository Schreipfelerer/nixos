{ config, pkgs, ... }:

{
  services.jellyfin.enable = true;
  
  services.sonarr.enable = true;

  services.radarr.enable = true;
  
  services.jellyseerr.enable = true;

  services.bazarr.enable = true;

  services.prowlarr.enable = true;

  services.sabnzbd.enable = true;

  # Transmission
}

