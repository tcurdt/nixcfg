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

  environment.systemPackages = [
    pkgs.docker-compose
    pkgs.regclient
    pkgs.envsubst
  ];

  # security.unprivilegedUsernsClone = true;

}
