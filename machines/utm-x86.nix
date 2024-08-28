{ nixpkgs, hostName, hostPlatform, impermanence, ... } @ inputs: let

  pkgs = nixpkgs.legacyPackages.${hostPlatform};

in nixpkgs.lib.nixosSystem {

  specialArgs = { inherit inputs; };

  modules = [

    # inputs.nixos-generators.nixosModules.all-formats
    # inputs.release-go.nixosModules.default

    ../hardware/utm-x86.nix
    ../modules/server.nix
    ../modules/users.nix

    # ../modules/k3s.nix
    # ../modules/rke2.nix
    # ../modules/podman.nix
    # ../modules/docker.nix

    # ../modules/prometheus.nix
    # ../modules/thanos.nix

    # ../modules/loki.nix
    # ../modules/promtail.nix

    # ../modules/grafana.nix

    # ../modules/telegraf.nix
    # ../modules/db-influx.nix

    # ../modules/db-postgres.nix
    # ../modules/redis.nix

    # ../modules/homeassistant.nix

    # ../modules/zerotierone.nix
    # ../modules/tailscale.nix

    # ../modules/hook-ssh.nix
    # ../modules/hook-web.nix

    # ../modules/backup.nix

    {
      nixpkgs.hostPlatform = hostPlatform;
      networking.hostName = hostName;
      networking.domain = "utm";
      system.stateVersion = "23.11";
    }

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

    # {
    #   services.release-go = {
    #     enable = true;
    #     port = 2020;
    #   };
    # }

    # {
    #   networking.interfaces.cluster.ipv4.addresses = [ {
    #     address = "172.16.1.1";
    #     prefixLength = 12;
    #   } ];
    # }

    # {
    #   networking.firewall.allowedTCPPorts = [ 80 443 ];
    #   services.caddy = {
    #     enable = true;

    #     # curl -k --resolve echo1.vafer.work:443:127.0.0.1 https://echo1.vafer.work

    #     virtualHosts."echo1.vafer.work" = {
    #       extraConfig = ''

    #         # if file "message.html" exist on disk show it

    #         # root * /etc/caddy/message

    #         @exists {
    #           file /etc/caddy/wewillbeback
    #         }

    #         handle @exists {
    #           respond "We will be back shortly" 503 {
    #             close
    #           }
    #         }

    #         # otherwise pass on to proxy

    #         handle {
    #           reverse_proxy echo1.default.svc.cluster.local:80
    #         }

    #         tls internal
    #       '';
    #     };

    #   };
    # }

  ];
}
