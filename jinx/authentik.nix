{ config, ... }:
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
      ExecStart = "${pkgs.docker}/bin/docker network create authentik-net";
      RemainAfterExit = true;
    };
  };
  
  sops.secrets."authentik/postgress/environment" = {};
  sops.secrets."authentik/db/environment" = {};
  sops.secrets."authentik/environment" = {};
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
      restartPolicy = "unless-stopped";
      environmentFiles = [
      	config.sops.secrets."authentik/postgress/environment".path
      ];
    };

    authentik-redis = {
      image = "redis:alpine";
      command = "--save 60 1 --loglevel warning";
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
      restartPolicy = "unless-stopped";
    };

    authentik-server = {
      image = "ghcr.io/goauthentik/server:2025.6.3";
      command = [ "server" ];
      environment = {
        AUTHENTIK_REDIS__HOST = "authentik-redis";
        AUTHENTIK_POSTGRESQL__HOST = "authentik-db";
        AUTHENTIK_POSTGRESQL__USER = "authentik";
        AUTHENTIK_POSTGRESQL__NAME = "authentik";
      };
      environmentFiles = [ 
        config.sops.secrets.db.environment.path
	config.sops.secrets.environment.path
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
      dependsOn = [ "authentik-db" "authentik-redis" ];
      restartPolicy = "unless-stopped";
    };

    authentik-worker = {
      image = "ghcr.io/goauthentik/server:2025.6.3";
      command = [ "worker" ];
      user = "root";
      environment = {
        AUTHENTIK_REDIS__HOST = "authentik-redis";
        AUTHENTIK_POSTGRESQL__HOST = "authentik-db";
        AUTHENTIK_POSTGRESQL__USER = "authentik";
        AUTHENTIK_POSTGRESQL__NAME = "authentik";
      };
      environmentFiles = [ 
        config.sops.secrets.db.environment.path
	config.sops.secrets.environment.path
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
      dependsOn = [ "authentik-db" "authentik-redis" ];
      restartPolicy = "unless-stopped";
    };
  };
}
