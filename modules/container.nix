{ config, pkgs, ... }:
{

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true; # required for podman-compose
      autoPrune = {
        enable = true;
        dates = "Monday 02:00";
        flags = [ "--all" ];
      };
    };
    oci-containers.backend = "podman";
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  # virtualisation.oci-containers.containers = {
  #    echo = {
  #       image = "ealen/echo-server";
  #       ports = [ "127.0.0.1:8080:80" ];
  #       # volumes = [
  #       #   "a:b"
  #       # ];
  #       # environment = {
  #       # };
  #       # extraOptions = [ "--pod=live-pc" ];
  #    };
  # };

  # security.unprivilegedUsernsClone = true;
  # networking.firewall.trustedInterfaces = [ "podman0" ]
  # networking.firewall.interfaces.podman0.allowedUDPPorts = [ 53 ];
  # virtualisation = {
  #   docker = {
  #     enable = true;
  #     # rootless = {
  #     #   enabled = true;
  #     #   setSocketVariable = true;
  #     # };
  #   };
  #   oci-containers.backend = "docker";
  # };
}
