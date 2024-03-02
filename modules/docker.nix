{ config, pkgs, ... }:
{

  virtualisation = {
    containers.enable = true;
    oci-containers.backend = "docker";

    docker = {
      enable = true;
      # rootless = {
      #   enabled = true;
      #   setSocketVariable = true;
      # };
    };
  };

  environment.systemPackages = builtins.attrValues {
    inherit (pkgs)
      docker-compose
      regclient
      envsubst
      ;
  };

  # security.unprivilegedUsernsClone = true;

}
