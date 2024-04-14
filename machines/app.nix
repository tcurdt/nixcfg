{ nixpkgs, hostName, hostPlatform, impermanence, ... } @ inputs: let

  pkgs = nixpkgs.legacyPackages.${hostPlatform};

in nixpkgs.lib.nixosSystem {

  specialArgs = { inherit inputs; };

  modules = [

    # inputs.nixos-generators.nixosModules.all-formats

    inputs.release-go.nixosModules.default

    ../hardware/hetzner.nix
    ../modules/server.nix
    ../modules/users.nix
    # ../modules/auth.nix

    # ../modules/docker.nix
    ../modules/podman.nix
    # ../modules/k3s.nix

    # ../modules/ntfy.nix
    ../modules/telegraf.nix
    ../modules/db-postgres.nix
    ../modules/db-influx.nix
    # ../modules/redis.nix

    # ../modules/zerotierone.nix
    # ../modules/tailscale.nix

    # ../modules/hook-ssh.nix
    # ../modules/hook-web.nix

    # ../modules/backup.nix

    {
      nixpkgs.hostPlatform = hostPlatform;
      networking.hostName = hostName;
      networking.domain = "nixos";
      system.stateVersion = "23.11";
      # system.stateVersion = "24.05";
    }

    ../users/root.nix
    ../users/tcurdt.nix
    # ../users/ops.nix
    # {
    #   ops.keyFiles = [
    #     ../keys/tcurdt.pub
    #   ];
    # }

    # {
    #   users.users.root.password = "secret";
    # }

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
        globalConfig = ''
          servers { metrics }
        '';

        # curl -k --resolve ntfy.vafer.org:443:127.0.0.1 https://ntfy.vafer.org
        # virtualHosts."ntfy.vafer.org" = {
        #   extraConfig = ''
        #     reverse_proxy 127.0.0.1:8080
        #   '';
        # };

        virtualHosts."auth.vafer.org" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:9091
          '';
        };

        virtualHosts."api.vafer.org" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:2020
          '';
        };

        virtualHosts."dev.vafer.org" = {
          extraConfig = ''
            reverse_proxy 127.0.0.1:2015
          '';
        };

        virtualHosts."foo.vafer.org" = {
          extraConfig = ''
            basicauth bcrypt Elasticsearch {
              import elasticsearch.auth
            }
            basicauth {
              # Username "Bob", password "hiccup"
              Bob $2a$14$Zkx19XLiW6VYouLHR5NmfOFU0z2GTNmpkT/5qqR7hx4IjWJPDhjvG
            }
            forward_auth 127.0.0.1:9091 {
              uri /api/verify?rd=https://auth.vafer.org
              copy_headers Remote-User Remote-Groups Remote-Name Remote-Email
            }
            reverse_proxy 127.0.0.1:2015
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
