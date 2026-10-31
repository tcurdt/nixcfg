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
    { services.k3s.package = pkgs.k3s_1_33; }
    ../modules/maintenance.nix

    ../users/root.nix
    ../users/ops.nix
    { ops.keyFiles = [ ../keys/tcurdt.pub ]; }

    {
      # create: nix run nixpkgs#mkpasswd -- -m sha-512
      # verify: su - root
      users.users.root.hashedPassword = "$6$/OBNw1chITrkLuVU$sZeOSyjQLGRdcm1DiOtKME8b9.odIJNlfXN8O/zQJL8uWYzUUYNmErApPc4eswfBDiFYHnrcpWuKpAFPZY99d1";
    }

    {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    }

  ];
}
