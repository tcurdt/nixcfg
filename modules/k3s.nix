{ config, pkgs, ... }:
{

  # so that pod can reach the API server
  # networking.firewall.allowedTCPPorts = [ 6443 ];

  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    # "--kubelet-arg=v=4" # Optionally add additional args to k3s
  ];
  environment.systemPackages = with pkgs; [
    k3s
    kubectx
  ];

}
