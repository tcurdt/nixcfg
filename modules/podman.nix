{ pkgs, ... }:
{

  # https://carjorvaz.com/posts/rootless-podman-and-docker-compose-on-nixos/
  virtualisation = {
    containers.enable = true;
    oci-containers.backend = "podman";

    podman = {
      enable = true;
      # dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
      # defaultNetwork.settings.dns_enabled = false;
      autoPrune = {
        enable = true;
        dates = "Monday 02:00";
        flags = [ "--all" ];
      };
    };

    # containers.storage.settings = {
    #   storage = {
    #     driver = "overlay";
    #     runroot = "/run/containers/storage";
    #     graphroot = "/var/lib/containers/storage";
    #     rootless_storage_path = "/tmp/containers-$USER";
    #     options.overlay.mountopt = "nodev,metacopy=on";
    #   };
    # };
  };

  environment.shellAliases = {
    p = "podman";
  };

  environment.systemPackages = [
    # pkgs.podman-compose
    pkgs.regclient
    pkgs.envsubst
    pkgs.podman-tui
  ];

  # https://carjorvaz.com/posts/rootless-podman-and-docker-compose-on-nixos/
  environment.extraInit = ''
    if [ -z "$DOCKER_HOST" -a -n "$XDG_RUNTIME_DIR" ]; then
      export DOCKER_HOST="unix://$XDG_RUNTIME_DIR/podman/podman.sock"
    fi
  '';

  # networking.firewall.trustedInterfaces = [ "podman0" ]
  # networking.firewall.interfaces.podman0.allowedUDPPorts = [ 53 ];

  # systemd.services.podman-gitops = {
  #   enable = true;
  #   description = "update podman from git";
  #   script = "${pkgs.writeScript "stage2" ''
  #     #!${pkgs.bash}/bin/bash
  #     git pull
  #     resolve
  #     podman play
  #     ''}";
  # };


}
