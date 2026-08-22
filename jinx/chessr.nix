{ inputs, pkgs, config, ... }:
  let
    chessrPkg = inputs.chessr.packages.${pkgs.system}.chessr;
    botConfig = (pkgs.formats.yaml { }).generate "lichess-bot-config.yaml" {
    url = "https://lichess.org/";
    engine = {
      dir = "${chessrPkg}/bin";
      name = "chessr";
      protocol = "uci";
      ponder = false;
      polyglot = {
        enabled = true;
        book.standard = [ "/var/lib/chessr/books/book.bin" ];
        selection = "weighted_random";
        min_weight = 1;
        max_depth = 8;
      };
    };
    challenge = {
      variants = [ "standard" ];
      time_controls = [ "bullet" "blitz" "rapid" ];
      modes = [ "casual" ];
    };
    greeting = {
      hello = "Hi, {opponent}!";
      goodbye = "Good game!";
    };
    max_takebacks_accepted = 3;
  };
in
{
  sops.secrets.lichess_token = { };

  systemd.services.chessr-lichess-bot = {
    description = "chessr on Lichess";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.lichess-bot}/bin/lichess-bot --disable_auto_logging --config ${botConfig}";
      DynamicUser = true;
      EnvironmentFile = config.sops.secrets.lichess_token.path;
    };
  };
}
