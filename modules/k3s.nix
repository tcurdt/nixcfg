{ config, pkgs, ... }:
{

  # networking.firewall.allowedTCPPorts = [ 6443 ];

  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    "--disable=traefik"
  ];

  environment.shellAliases = {
    k = "kubectl";
  };

  environment.variables = {
    KUBECONFIG="/etc/rancher/k3s/k3s.yaml";
  };

  environment.systemPackages = with pkgs; [
    k3s
    k9s
    regclient
    kustomize
    envsubst
    # kubectx
  ];

}
