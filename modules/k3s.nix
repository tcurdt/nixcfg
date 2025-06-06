{
  pkgs,
  ...
}:
{

  # networking.firewall.allowedTCPPorts = [
  #   6443 # k3s: required so that pods can reach the API server (running on port 6443 by default)
  #   2379 # k3s, etcd clients: required if using a "High Availability Embedded etcd" configuration
  #   2380 # k3s, etcd peers: required if using a "High Availability Embedded etcd" configuration
  # ];
  # networking.firewall.allowedUDPPorts = [
  #   # 8472 # k3s, flannel: required if using multi-node for inter-node networking
  # ];

  services.k3s = {
    enable = true;
    role = "server";
    # token = "secret";
    # clusterInit = true;
    # serverAddr = "https://<ip of first node>:6443";
    extraFlags = toString [
      "--disable=traefik"
      "--disable=metrics-server"
      # "--disable=servicelb"
      # "--disable-cloud-controller"
      # "--disable-kube-proxy"
      # "--disable-network-policy"
      # "--disable-helm-controller"
      "--write-kubeconfig-mode 00640"
      "--write-kubeconfig-group wheel"
    ];
    # sudo cp /etc/rancher/k3s/k3s.yaml ~/.kube/config && sudo chown $USER ~/.kube/config && chmod 600 ~/.kube/config
  };

  # networking.nameservers = [ "10.43.0.10" ];

  # environment.shellAliases = {
  #   k  = "kubectl";
  #   kall = "kubectl get all -A";
  # };

  environment.variables = {
    KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
  };

  # systemd.tmpfiles.rules = [ "f /etc/rancher/k3s/k3s.yaml 0640 root wheel -" ];

  environment.systemPackages = [
    pkgs.k3s
    pkgs.k9s
    pkgs.kubetail
    pkgs.kubernetes-helm
    pkgs.envsubst
    pkgs.kustomize
    pkgs.kubectx
    pkgs.regclient
    # pkgs.kor # unstable
    # pkgs.stern
    # pkgs.velero
  ];

}
