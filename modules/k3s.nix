{ config, pkgs, ... }:
{

  # networking.firewall.allowedTCPPorts = [ 6443 ];

  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    "--disable=traefik"
  ];

  # environment.shellAliases = {
  #   k9 = "k9s --kubeconfig /etc/rancher/k3s/k3s.yaml";
  # };

  environment.variables = {
    KUBECONFIG=/etc/rancher/k3s/k3s.yaml;
  };

  environment.systemPackages = with pkgs; [
    k3s
    k9s
    kubectx
  ];

}
