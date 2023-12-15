{ nixpkgs, ... }: let

  hardware = "utm";
  hostPlatform = "aarch64-linux";
  hostName = "nixos";

in nixpkgs.lib.nixosSystem {

  modules = [
    ../hardware/${hardware}.nix
    ../modules/server.nix
    ../modules/users.nix
    # ../modules/k3s.nix
    ../modules/podman.nix
    # ../modules/docker.nix
    # ../modules/ssh-hook.nix
    # ../modules/web-hook.nix

    {
      nixpkgs.hostPlatform = hostPlatform;
      networking.hostName = hostName;
      networking.domain = "utm";
      system.stateVersion = "23.11";
    }

    {
      services.caddy = {
        enable = true;

        # curl -k --resolve whoami.vafer.work:443:127.0.0.1 https://whoami.vafer.work
        virtualHosts."whoami.vafer.work" = {
          extraConfig = ''
            reverse_proxy http://127.0.0.1:8080
          '';
        };
      };
    }

    {
      virtualisation.oci-containers.containers = {
        whoami = {
          image = "docker.io/traefik/whoami:v1.9.0";
          # image = "ealen/echo-server";
          ports = [ "127.0.0.1:8080:80" ];
          # volumes = [
          #   "a:b"
          # ];
          # environment = {
          # };
          # extraOptions = [ "--pod=foo" ];
        };
      };
    }

    # podman network create foo
    # podman pod create --network foo --publish 80 foo
    # podman run --pod foo --name foo-frontend -dt docker.io/traefik/whoami:v1.9.0

  ];
}
