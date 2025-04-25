{
  # pkgs,
  ...
}:
{

  networking.hostName = "home-goe";
  networking.domain = "home";
  system.stateVersion = "23.11";

  imports = [

    ../hardware/lenovo.nix

    ../modules/server.nix
    ../modules/users.nix

    ../users/root.nix
    ../users/ops.nix
    { ops.keyFiles = [ ../keys/tcurdt.pub ]; }

    { users.users.root.password = "secret"; }

    # ../modules/telegraf.nix
    # ../modules/db-influx.nix
    # ../modules/homeassistant.nix

    # ../modules/zerotierone.nix
    # ../modules/tailscale.nix

    {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
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

          watchtower = {
            autoStart = true;
            image = "containrrr/watchtower";
            environmentFiles = [
              "/run/credentials/env.watchtower"
              # https://containrrr.dev/shoutrrr/v0.8/getting-started/
              # WATCHTOWER_NOTIFICATION_URL=pushover://shoutrrr:<api>@<user>/?devices=iphone
              # WATCHTOWER_NOTIFICATION_TITLE_TAG="[home-goe]"
              # WATCHTOWER_NOTIFICATIONS_LEVEL="info"
            ];
            cmd = [
              # https://containrrr.dev/watchtower/arguments/
              "--interval=60"
              "--label-enable=true"
              "--rolling-restart=true"
            ];
            volumes = [
              # https://containrrr.dev/watchtower/private-registries/
              "/run/credentials/docker.registries:/config.json"
              "/var/run/docker.sock:/var/run/docker.sock"
            ];
          };

          test = {
            image = "ghcr.io/tcurdt/test-project:test";
            labels = {
              "com.centurylinklabs.watchtower.enable" = "true";
            };

            ports = [ "127.0.0.1:2015:2015" ];

            environmentFiles = [ "/run/credentials/env.test" ];

            login = {
              registry = "ghcr.io";
              username = "tcurdt";
              passwordFile = "/run/credentials/password.registry.github";
            };
          };

        };
      };
    }

  ];
}
