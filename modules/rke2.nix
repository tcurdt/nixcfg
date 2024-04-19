{ config, pkgs, ... }:
{

  # networking.firewall.allowedTCPPorts = [ 6443 ];

  environment.shellAliases = {
    k = "kubectl";
  };

  environment.variables = {
    # KUBECONFIG="/etc/rancher/k3s/k3s.yaml";
  };

  environment.systemPackages = [
    pkgs.rke2
    pkgs.regclient
    pkgs.kustomize
    pkgs.envsubst
    pkgs.k9s
    # pkgs.kubectx
  ];

}
