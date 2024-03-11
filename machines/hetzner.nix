{ nixpkgs, impermanence, ... } @ inputs: let

  hardware = "hetzner";
  hostPlatform = "x86_64-linux";
  hostName = "nixos";

  pkgs = nixpkgs.legacyPackages.${hostPlatform};

in nixpkgs.lib.nixosSystem {

  specialArgs = { inherit inputs; };

  modules = [
    inputs.release-go.nixosModules.default
    ../hardware/${hardware}.nix
    ../modules/server.nix
    ../modules/users.nix

    # ../modules/docker.nix
    # ../modules/podman.nix
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
      networking.domain = "nixos";
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
      networking.firewall.allowedTCPPorts = [ 80 443 ];
      services.caddy = {
        enable = true;
        email = "tcurdt@vafer.org";

        # curl -k --resolve ntfy.vafer.org:443:127.0.0.1 https://ntfy.vafer.org
        virtualHosts."ntfy.vafer.org" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:8080
          '';
        };

        virtualHosts."api.vafer.org" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:2020
          '';
        };

      };
    }

  ];
}
