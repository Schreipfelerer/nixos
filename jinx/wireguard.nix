{ config, pkgs, ... }:

{
  sops.secrets."wireguard/host" = {};
  networking.wireguard = {
    interfaces = {
      wg0 = {
        privateKeyFile = config.sops.secrets."wireguard/host".path;
        listenPort = 51820; # default WireGuard port
        ips = [ "10.200.0.1/24" ];
        peers = [
          {
            publicKey = "rJBFWmWjJfHwwW/EAfZJ4DX90sVPfoM1I7IoYv7H5hI=";
            allowedIPs = [ "10.200.0.2/32" ]; # client IP in VPN
          }
        ];
      };
    };
  };
  networking.nat = {
    enable = true;
    externalInterface = "enp8s0";
    internalInterfaces = [ "wg0" ];
  };

  # Allow WireGuard traffic through firewall
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
    trustedInterfaces = [ "wg0" ];
  };
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
}
