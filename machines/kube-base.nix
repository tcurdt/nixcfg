{
  # pkgs,
  ...
}:
{

  networking.hostName = "kube-base";
  networking.domain = "nixos";
  system.stateVersion = "24.11";

  imports = [

    ../hardware/hetzner.nix
    ../modules/server.nix
    ../modules/users.nix

    ../users/root.nix
    ../users/ops.nix
    {
      ops.keyFiles = [
        ../keys/tcurdt.pub
      ];
    }

    # {
    #   networking.firewall.allowedTCPPorts = [
    #     80
    #     443
    #   ];
    # }

  ];
}
