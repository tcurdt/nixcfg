{ pkgs, ... }: {

  networking.hostName = "home-goe";
  networking.domain = "home";
  system.stateVersion = "23.11";

  imports = [

    ../hardware/lenovo.nix

    ../modules/server.nix
    ../modules/users.nix

    ../users/root.nix
    ../users/ops.nix
    {
      ops.keyFiles = [
        ../keys/tcurdt.pub
      ];
    }

    {
      users.users.root.password = "secret";
    }

    # ../modules/telegraf.nix
    # ../modules/db-influx.nix
    # ../modules/homeassistant.nix

    # ../modules/zerotierone.nix
    # ../modules/tailscale.nix

    {
      networking.firewall.allowedTCPPorts = [ 80 443 ];
      services.caddy = {
        enable = true;

        # virtualHosts."homeassistant.home" = {
        #   extraConfig = ''
        #     reverse_proxy 127.0.0.1:2020
        #     tls internal
        #   '';
        # };

      };
    }

    {
        virtualisation.docker.daemon.settings = {
            userland-proxy = false;
            experimental = true;
            metrics-addr = "0.0.0.0:9323";
            ipv6 = false;
            log-driver = "journald";
            log-level = "info";
        };

        virtualisation.oci-containers = {
        backend = "docker";
        containers = {

          test = {
            image = "ghcr.io/tcurdt/test-project:test";
            ports = [ "127.0.0.1:2015:2015" ];

            environmentFiles = [
              /run/credentials/live.password
            ];

            # extraOptions = [
            #   "--network=testing"
            # ];

            login = {
              registry = "ghcr.io";
              username = "tcurdt";
              passwordFile = "/run/credentials/registry.github";
            };
          };

        };
      };
    }

  ];
}
