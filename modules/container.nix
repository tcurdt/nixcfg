{ config, pkgs, ... }:
{

  # # This is required so that pod can reach the API server (running on port 6443 by default)
  # networking.firewall.allowedTCPPorts = [ 6443 ];
  # services.k3s.enable = true;
  # services.k3s.role = "server";
  # services.k3s.extraFlags = toString [
  #   # "--kubelet-arg=v=4" # Optionally add additional args to k3s
  # ];
  # environment.systemPackages = [ pkgs.k3s ];

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

  # https://carjorvaz.com/posts/rootless-podman-and-docker-compose-on-nixos/
  virtualisation = {

    graphics = false;

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
  # networking.firewall.trustedInterfaces = [ "podman0" ]
  # networking.firewall.interfaces.podman0.allowedUDPPorts = [ 53 ];

  environment.systemPackages = with pkgs; [
    # docker-compose
    podman-compose
  ];
  # environment.extraInit = ''
  #   if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
  #     export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
  #   fi
  # '';

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

}
