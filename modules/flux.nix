{ pkgs, ... }:
{

  services.k3s = {

    manifests.flux-operator.content = {
      apiVersion = "helm.cattle.io/v1";
      kind = "HelmChart";
      metadata = {
        name = "flux-operator";
        namespace = "flux-system";
      };
      spec = {
        targetNamespace = "flux-system";
        createNamespace = true;
        repo = "oci://ghcr.io/controlplaneio-fluxcd/charts";
        chart = "flux-operator";
        # version = "18.3.5";

        # valuesContent = ''
        #   replicaCount: 3
        #   tls:
        #     enabled: false
        #   metrics:
        #     enabled: true
        # '';
      };
    };

    manifests.flux-instance.content = {
      apiVersion = "helm.cattle.io/v1";
      kind = "HelmChart";
      metadata = {
        name = "flux-instance";
        namespace = "flux-system";
      };
      spec = {
        targetNamespace = "flux-system";
        createNamespace = true;
        repo = "oci://ghcr.io/controlplaneio-fluxcd/charts";
        chart = "flux-instance";
        # version = "18.3.5";

        # valuesContent = ''
        #   replicaCount: 3
        #   tls:
        #     enabled: false
        #   metrics:
        #     enabled: true
        # '';

        # values = [file("${path.module}/flux.components.yaml")]

        # set {
        #   name  = "instance.env[0].name"
        #   value = "SOPS_AGE_KEY_FILE"
        # }

        # set {
        #   name  = "instance.env[0].value"
        #   value = "/home/flux/.config/sops/age/age.agekey"
        # }

        # # flux

        # set {
        #   name  = "instance.distribution.registry"
        #   value = "ghcr.io/fluxcd"
        # }

        # set {
        #   name  = "instance.distribution.version"
        #   value = "2.x"
        # }

        # # git

        # set {
        #   name  = "instance.sync.kind"
        #   value = "GitRepository"
        # }

        # set {
        #   name  = "instance.sync.url"
        #   value = var.flux_repository
        # }

        # set {
        #   name  = "instance.sync.path"
        #   value = var.flux_path
        # }

        # set {
        #   name  = "instance.sync.ref"
        #   value = "refs/heads/${var.flux_branch}"
        # }

        # set {
        #   name  = "instance.sync.pullSecret"
        #   value = kubernetes_secret.flux_git.metadata[0].name
        # }

      };
    };

  };

  environment.systemPackages = [
    pkgs.kustomize
    pkgs.helm
  ];

}
