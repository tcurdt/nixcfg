{ nixpkgs, impermanence, ... }@inputs: let

  hardware = "utm";
  hostPlatform = "aarch64-linux";
  hostName = "nixos";

  pkgs = nixpkgs.legacyPackages.${hostPlatform};

in nixpkgs.lib.nixosSystem {

  specialArgs = { inherit inputs; };

  modules = [
    # inputs.home-manager.nixosModules.home-manager
    # inputs.home-manager.nixosModules.default
    inputs.release-go.nixosModules.default
    # agenix.nixosModules.default
    ../hardware/${hardware}.nix
    ../modules/server.nix
    ../modules/users.nix

    # ../modules/docker.nix
    ../modules/podman.nix
    # ../modules/k3s.nix

    ../modules/ntfy.nix
    ../modules/telegraf.nix
    ../modules/db-postgres.nix
    ../modules/db-influx.nix
    ../modules/redis.nix

    # ../modules/ssh-hook.nix
    # ../modules/web-hook.nix

    # ../modules/backup.nix

    {
      nixpkgs.hostPlatform = hostPlatform;
      networking.hostName = hostName;
      networking.domain = "utm";
      system.stateVersion = "23.11";
    }

    ../users/root.nix
    ../users/tcurdt.nix

    {
      users.users.root.password = "secret";
    }

    {
      services.release-go = {
        enable = true;
        port = 2020;
      };
    }

    {
      services.caddy = {
        enable = true;

        # curl -k --resolve ntfy.vafer.org:443:127.0.0.1 https://ntfy.vafer.org
        virtualHosts."ntfy.vafer.org" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:8080
            tls internal
          '';
        };

        virtualHosts."api.vafer.org" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:2020
            tls internal
          '';
        };

        virtualHosts."dev.vafer.org" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:2015
            tls internal
          '';
        };

      };
    }

    # {
    #   virtualisation.oci-containers.containers = {

    #     test = {
    #       image = "ghcr.io/tcurdt/test-project";
    #       ports = [ "127.0.0.1:2015:2015" ];
    #       #environment = {
    #       #  PASSWORD = "foo";
    #       #};
    #       environmentFiles = [
    #         /run/credentials/live.password
    #       ];
    #       # extraOptions = [
    #       #   "--network=testing"
    #       # ];
    #       login = {
    #         registry = "ghcr.io";
    #         username = "tcurdt";
    #         passwordFile = "/run/credentials/registry.github";
    #       };
    #     };

    #     test2 = {
    #       image = "ghcr.io/tcurdt/test-project";
    #       ports = [ "127.0.0.1:2016:2016" ];
    #       environment = {
    #         URL = "https://127.0.0.1:2015/version";
    #       };
    #       environmentFiles = [
    #         /run/credentials/live.password
    #       ];
    #       # extraOptions = [
    #       #  "--network=testing"
    #       # ];
    #       login = {
    #         registry = "ghcr.io";
    #         username = "tcurdt";
    #         passwordFile = "/run/credentials/registry.github";
    #       };
    #     };

    #   };
    # }

  ];
}
