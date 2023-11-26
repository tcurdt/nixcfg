{ config, pkgs, ... }:
{

  # https://carjorvaz.com/posts/rootless-podman-and-docker-compose-on-nixos/
  virtualisation = {
    containers.enable = true;
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

    containers.storage.settings = {
      storage = {
        driver = "overlay";
        runroot = "/run/containers/storage";
        graphroot = "/var/lib/containers/storage";
        rootless_storage_path = "/tmp/containers-$USER";
        options.overlay.mountopt = "nodev,metacopy=on";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    podman-compose
  ];

  # networking.firewall.trustedInterfaces = [ "podman0" ]
  # networking.firewall.interfaces.podman0.allowedUDPPorts = [ 53 ];

  # environment.extraInit = ''
  #   if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
  #     export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
  #   fi
  # '';

}
