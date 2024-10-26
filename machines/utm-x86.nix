{ pkgs, ... }:
{

  networking.hostName = "utm-x86";
  networking.domain = "utm";
  system.stateVersion = "23.11";

  imports = [

    ../hardware/utm-x86.nix

    ../modules/server.nix
    ../modules/users.nix

    ../users/root.nix
    ../users/ops.nix
    { ops.keyFiles = [ ../keys/tcurdt.pub ]; }

    { users.users.root.password = "secret"; }

  ];
}
