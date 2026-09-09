{ ... }:
{
  virtualisation.oci-containers.containers."its-mytabs" = {
    image = "louislam/its-mytabs:1";
    ports = [ "47777:47777" ];
    volumes = [
      "/var/lib/its-mytabs/data:/app/data"
    ];
    autoStart = true;
  };
}
