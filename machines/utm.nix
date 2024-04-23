{ nixpkgs, hostName, hostPlatform, impermanence, ... } @ inputs: let

  pkgs = nixpkgs.legacyPackages.${hostPlatform};

in nixpkgs.lib.nixosSystem {

  specialArgs = { inherit inputs; };

  modules = [

    # inputs.nixos-generators.nixosModules.all-formats
    # inputs.release-go.nixosModules.default

    ../hardware/utm.nix
    ../modules/server.nix
    ../modules/users.nix

    ../modules/docker.nix
    # ../modules/podman.nix
    # ../modules/k3s.nix
    # ../modules/rke2.nix

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
      # system.stateVersion = "24.05";
    }

    ../users/root.nix
    ../users/tcurdt.nix

    {
      users.users.root.password = "secret";
    }

    # {
    #   services = {
    #     qemuGuest.enable = true;
    #     openssh.settings.PermitRootLogin = lib.mkForce "yes";
    #   };
    # }

    # {
    #   services.release-go = {
    #     enable = true;
    #     port = 2020;
    #   };
    # }

    {
      networking.firewall.allowedTCPPorts = [ 80 443 ];
    }

    # {
    #   networking.firewall.allowedTCPPorts = [ 80 443 ];
    #   services.caddy = {
    #     enable = true;

    #     # curl -k --resolve ntfy.vafer.org:443:127.0.0.1 https://ntfy.vafer.org

    #     # virtualHosts."dev.vafer.org" = {
    #     #   extraConfig = ''
    #     #     reverse_proxy 127.0.0.1:2015
    #     #     tls internal
    #     #   '';
    #     # };

    #   };
    # }

  ];
}
