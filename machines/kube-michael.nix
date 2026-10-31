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
      users.users.root.hashedPassword = "$6$Eozf9e/DlpROw8Jb$sfOqOMwgH9fp5hOtUysCTRNdcA1/twTZ8BzosZ3hp8.BGFZG3Ga2z3G3Yq6PWI8F3fpEzpDkNJ.g7ceysygS00";
    }

    {
      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    }

  ];
}
