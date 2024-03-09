{ config, pkgs, ... }:
{
  virtualisation.oci-containers.containers = {

    whoami = {
      image = "docker.io/traefik/whoami:v1.9.0";
      # image = "ghcr.io/tcurdt/foo:live";
      # image = "ghcr.io/tcurdt/foo:test";
      ports = [ "127.0.0.1:8080:80" ];
      # volumes = [
      #   "a:b"
      # ];
      # environment = {
      # };
      # extraOptions = [ "--pod=foo" ];
    };

    # skyguard = {
    #   image = "ghcr.io/tcurdt/skyguard:latest";
    #   ports = [ "127.0.0.1:8081:2015" ];
    #   environment = {
    #     PGHOST = "127.0.0.1";
    #     PGDATABASE = "bluesky";
    #     PGUSER = "postgres";
    #     PGPASSWORD = "secret";
    #     SERVICE = "dev.vafer.org";
    #   };
    #   login = {
    #     registry = "ghcr.io";
    #     username = "tcurdt";
    #     passwordFile = "/run/secrets/registry.github";
    #   };
    # };

  };
}

# podman network create foo
# podman pod create --network foo --publish 80 foo
# podman run --pod foo --name foo-frontend -dt docker.io/traefik/whoami:v1.9.0
