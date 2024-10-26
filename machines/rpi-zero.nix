{ pkgs, ... }:
{

  networking.hostName = "rpi-zero";
  networking.domain = "home";
  system.stateVersion = "23.11";

  imports = [

    ../hardware/rpi-zero.nix

    ../modules/rpi.nix
    ../modules/users.nix

    ../users/root.nix
    ../users/ops.nix
    { ops.keyFiles = [ ../keys/tcurdt.pub ]; }

    { users.users.root.password = "secret"; }

  ];
}
