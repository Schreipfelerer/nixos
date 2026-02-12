{ config, pkgs, ... }:
{

  services.resolved.enable = true;

  sops.secrets."wireguard/ekko" = { };

  systemd.services."wireguard-wg0".after = [ "network-online.target" ];
  systemd.services."wireguard-wg0".wants = [ "network-online.target" ];
  networking.wireguard.interfaces.wg0 = {
    ips = [ "10.200.0.2/24" ];
    privateKeyFile = config.sops.secrets."wireguard/ekko".path;
    postSetup = ''
      resolvectl dns wg0 192.168.178.24
      resolvectl domain wg0 '~thabo.internal'
    '';

    postShutdown = ''
      resolvectl revert wg0
    '';
    peers = [
      {
        publicKey = "1ysNoCfRvjzKgXziDDRVb3I0AGAKCJj3m/QmTdiB+0I=";
        endpoint = "home.thabo.dev:51820";

        # Route host LAN + WG subnet
        allowedIPs = [
          "10.200.0.0/24"
          "192.168.178.0/24"
        ];

        persistentKeepalive = 25;
      }
    ];
  };
}
