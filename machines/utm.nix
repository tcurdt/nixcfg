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
      virtualisation.oci-containers.containers = {
        echo = {
          #image = "ealen/echo-server";
          image = "docker.io/traefik/whoami:v1.9.0";
          ports = [ "127.0.0.1:8080:80" ];
          # volumes = [
          #   "a:b"
          # ];
          # environment = {
          # };
          extraOptions = [ "--pod=foo" ];
        };
      };
    }

  ];
}
