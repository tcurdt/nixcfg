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
      virtualisation.oci-containers.containers = {

        test = {
          image = "ghcr.io/tcurdt/test-project";
          ports = [ "127.0.0.1:2015:2015" ];

          #environment = {
          #  PASSWORD = "foo";
          #};
          environmentFiles = [
            /run/credentials/live.password
          ];

          # extraOptions = [
          #   "--network=testing"
          # ];

          # login = {
          #   registry = "ghcr.io";
          #   username = "tcurdt";
          #   passwordFile = "/run/credentials/registry.github";
          # };
        };

      };
    }

  ];
}
