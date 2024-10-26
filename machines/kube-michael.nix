{ pkgs, ... }:
{

  networking.hostName = "kube-michael";
  networking.domain = "nixos";
  system.stateVersion = "24.05";

  imports = [

    ../hardware/hetzner.nix
    ../modules/server.nix
    ../modules/users.nix

    ../modules/k3s.nix
    ../modules/maintenance.nix

    ../users/root.nix
    ../users/ops.nix
    { ops.keyFiles = [ ../keys/tcurdt.pub ]; }

    {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    }

  ];
}
