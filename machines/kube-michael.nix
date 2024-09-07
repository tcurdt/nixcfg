{ pkgs, inputs, ... }: let

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

in {

  networking.hostName = "kube-michael";
  networking.domain = "nixos";
  system.stateVersion = "24.05";

  imports = [

    ../hardware/hetzner.nix
    ../modules/server.nix
    ../modules/users.nix

    ../modules/k3s.nix

    ../users/root.nix
    ../users/ops.nix
    {
      ops.keyFiles = [
        ../keys/tcurdt.pub
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
