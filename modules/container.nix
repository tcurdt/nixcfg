{ config, pkgs, ... }:
{

  # https://carjorvaz.com/posts/rootless-podman-and-docker-compose-on-nixos/
  virtualisation = {

    containers.enable = true;
    containers.storage.settings = {
      storage = {
        driver = "overlay";
        runroot = "/run/containers/storage";
        graphroot = "/var/lib/containers/storage";
        rootless_storage_path = "/tmp/containers-$USER";
        options.overlay.mountopt = "nodev,metacopy=on";
      };
    };

    oci-containers.backend = "podman";

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
  };

  environment.systemPackages = with pkgs; [
    docker-compose
  ];
  environment.extraInit = ''
    if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    fi
  '';

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
