{ nixpkgs, hostName, impermanence, ... } @ inputs: let

  hostPlatform = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${hostPlatform};

  maintenanceScript = pkgs.writeScriptBin "maintenance" ''
    #!${pkgs.bash}/bin/bash

    if [ "$1" == "on" ]; then
      touch /srv/volumes/cdn/maintenance
      exit 0
    fi

    if [ "$1" == "off" ]; then
      rm -f /srv/volumes/cdn/maintenance
      exit 0
    fi

    echo "usage: maintenance [on|off]"
    exit 1
  '';


in nixpkgs.lib.nixosSystem {

  specialArgs = { inherit inputs; };

  modules = [

    ../hardware/hetzner.nix
    ../modules/server.nix
    ../modules/users.nix

    ../modules/k3s.nix

    {
      networking.hostName = hostName;
      networking.domain = "nixos";
      system.stateVersion = "24.05";
    }

    ../users/root.nix
    ../users/ops.nix
    {
      ops.keyFiles = [
        ../keys/tcurdt.pub
        ../keys/kai.pub
        ../keys/swaack.pub
      ];
      users.users.ops = {
        packages = [ maintenanceScript ];
      };
    }

    {
      networking.firewall.allowedTCPPorts = [ 80 443 ];
    }

  ];
}
