
{ config, pkgs, ... }:
{
  sops.secrets."wireguard/ekko" = {};
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.200.0.2/24" ];
    privateKeyFile = config.sops.secrets."wireguard/ekko".path;

    peers = [
      {
        publicKey = "1ysNoCfRvjzKgXziDDRVb3I0AGAKCJj3m/QmTdiB+0I=";
        endpoint = "home.thabo.dev:51820";

        # Route host LAN + WG subnet
        allowedIPs = [
          "10.200.0.0/24"
          "192.168.1.0/24"
        ];

        persistentKeepalive = 25;
      }
    ];
  };
}

