{
  # pkgs,
  ...
}:
{

  networking.hostName = "kube-edkimo";
  networking.domain = "nixos";
  system.stateVersion = "24.05";

  imports = [

    ../hardware/hetzner.nix
    ../modules/server.nix
    ../modules/users.nix

    ../modules/k3s.nix
    ../modules/maintenance.nix
    # ../modules/maintenance.nix { inherit pkgs; file = "/some/other/path"; }

    ../users/root.nix
    ../users/ops.nix
    {
      ops.keyFiles = [
        ../keys/tcurdt.pub
        ../keys/kai.pub
        ../keys/swaack.pub
      ];
    }

    {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    }

  ];
}
