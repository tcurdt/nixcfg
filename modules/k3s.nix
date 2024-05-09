{ config, pkgs, ... }:
{

  # networking.firewall.allowedTCPPorts = [ 6443 ];

  services.k3s.enable = true;
  services.k3s.role = "server";
  services.k3s.extraFlags = toString [
    "--disable=traefik"
    # "--disable=servicelb"
    # "--disable=metrics-server"
    # "--disable-cloud-controller"
    # "--disable-kube-proxy"
    # "--disable-network-policy"
    # "--disable-helm-controller"
  ];

  networking.nameservers = [ "10.43.0.10" ];

  environment.shellAliases = {
    k = "kubectl";
  };

  environment.variables = {
    KUBECONFIG="/etc/rancher/k3s/k3s.yaml";
  };

  environment.systemPackages = [
    pkgs.k3s
    pkgs.regclient
    pkgs.kustomize
    pkgs.envsubst
    pkgs.k9s
    # pkgs.kubectx
  ];

}
