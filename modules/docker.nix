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
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  # security.unprivilegedUsernsClone = true;

}
