{ config, pkgs, ... }:
{
  # Docker network for Authentik
  systemd.services."create-docker-network-authentik-net" = {
    wantedBy = [ "multi-user.target" ];
    before = [
      "docker-authentik-db.service"
      "docker-authentik-redis.service"
      "docker-authentik-server.service"
      "docker-authentik-worker.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''
        ${pkgs.bash}/bin/bash -c '
          if ! ${pkgs.docker}/bin/docker network inspect authentik-net >/dev/null 2>&1; then
            ${pkgs.docker}/bin/docker network create authentik-net
          fi
        '
      '';
      RemainAfterExit = true;
    };
  };

  sops.secrets."authentik/postgres/environment" = { };
  sops.secrets."authentik/db/environment" = { };
  sops.secrets."authentik/email/environment" = { };
  sops.secrets."authentik/environment" = { };
  virtualisation.oci-containers.containers = {
    authentik-db = {
      image = "postgres:16-alpine";
      environment = {
        POSTGRES_USER = "authentik";
        POSTGRES_DB = "authentik";
      };
      volumes = [
        "/var/lib/authentik/database:/var/lib/postgresql/data"
      ];
      extraOptions = [
        "--network=authentik-net"
        "--health-cmd=pg_isready -d authentik -U authentik"
        "--health-start-period=20s"
        "--health-interval=30s"
        "--health-retries=5"
        "--health-timeout=5s"
      ];
      environmentFiles = [
        config.sops.secrets."authentik/postgres/environment".path
      ];
    };

    authentik-redis = {
      image = "redis:alpine";
      cmd = [
        "--save"
        "60"
        "1"
        "--loglevel"
        "warning"
      ];
      volumes = [
        "/var/lib/authentik/redis:/data"
      ];
      extraOptions = [
        "--network=authentik-net"
        "--health-cmd=redis-cli ping | grep PONG"
        "--health-start-period=20s"
        "--health-interval=30s"
        "--health-retries=5"
        "--health-timeout=3s"
      ];
    };

    authentik-server = {
      image = "ghcr.io/goauthentik/server:2025.6.3";
      cmd = [ "server" ];
      environment = {
        AUTHENTIK_REDIS__HOST = "authentik-redis";
        AUTHENTIK_POSTGRESQL__HOST = "authentik-db";
        AUTHENTIK_POSTGRESQL__USER = "authentik";
        AUTHENTIK_POSTGRESQL__NAME = "authentik";

        # SMTP Host Emails are sent to
        AUTHENTIK_EMAIL__HOST = "mail.your-server.de";
        AUTHENTIK_EMAIL__PORT = "465";
        AUTHENTIK_EMAIL__USE_TLS = "false";
        AUTHENTIK_EMAIL__USE_SSL = "true";
        AUTHENTIK_EMAIL__TIMEOUT = "10";
        AUTHENTIK_EMAIL__FROM = "sso@thabo.dev";
      };
      environmentFiles = [
        config.sops.secrets."authentik/db/environment".path
        config.sops.secrets."authentik/email/environment".path
        config.sops.secrets."authentik/environment".path
      ];
      volumes = [
        "/var/lib/authentik/media:/media"
        "/var/lib/authentik/custom-templates:/templates"
      ];
      ports = [
        "9000:9000"
        "9443:9443"
      ];
      extraOptions = [
        "--network=authentik-net"
      ];
      dependsOn = [
        "authentik-db"
        "authentik-redis"
      ];
    };

    authentik-worker = {
      image = "ghcr.io/goauthentik/server:2025.6.3";
      cmd = [ "worker" ];
      user = "root";
      environment = {
        AUTHENTIK_REDIS__HOST = "authentik-redis";
        AUTHENTIK_POSTGRESQL__HOST = "authentik-db";
        AUTHENTIK_POSTGRESQL__USER = "authentik";
        AUTHENTIK_POSTGRESQL__NAME = "authentik";
      };
      environmentFiles = [
        config.sops.secrets."authentik/db/environment".path
        config.sops.secrets."authentik/environment".path
      ];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
        "/var/lib/authentik/media:/media"
        "/var/lib/authentik/certs:/certs"
        "/var/lib/authentik/custom-templates:/templates"
      ];
      extraOptions = [
        "--network=authentik-net"
      ];
      dependsOn = [
        "authentik-db"
        "authentik-redis"
      ];
    };
  };
}
