{ pkgs, ... }: let

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

# { pkgs, config, ... }: {
#   options.tcurdt.myModule.file = lib.mkOption { type = lib.types.str; default = "/some/path"; };
#   config = {
#     # …rest of module goes here and references config.tcurdt.myModule.file…
#   };
# }