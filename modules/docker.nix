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

  services.journald.extraConfig = ''
    MaxLevelStore=notice
    MaxLevelSyslog=notice
  '';

  # systemd.units."run-docker-.mount" = {
  #   overrideStrategy = "asDropin";
  #   text = ''
  #     [Mount]
  #     LogLevelMax=0
  #   '';
  # };

  # systemd.services.docker.serviceConfig.LogLevelMax = 0;
  # systemd.services.docker.serviceConfig.LogFilterPatterns = [
  #   "run-docker-runtime"
  # ];

  environment.systemPackages = [
    pkgs.docker-compose
    pkgs.regclient
    pkgs.envsubst
  ];

  # security.unprivilegedUsernsClone = true;

}
