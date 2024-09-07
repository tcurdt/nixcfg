{ nixpkgs, hostName, impermanence, ... } @ inputs: let

  hostPlatform = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${hostPlatform};

in nixpkgs.lib.nixosSystem {

  specialArgs = { inherit inputs; };

  modules = [

    {
      networking.hostName = hostName;
      networking.domain = "home";
      system.stateVersion = "23.11";
    }

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

  ];
}
