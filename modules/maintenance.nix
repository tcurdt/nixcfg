# { pkgs, file ? "/srv/volumes/cdn/maintenance",... }: let
{ pkgs, file,... }: let

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

  users.users.ops = {
    packages = [ maintenanceScript ];
  };

}
