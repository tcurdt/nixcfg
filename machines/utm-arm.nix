{ pkgs, ... }: {

  networking.hostName = "utm-arm";
  networking.domain = "utm";
  system.stateVersion = "23.11";

  imports = [

    ../hardware/utm-arm.nix

    ../modules/server.nix
    ../modules/users.nix

    ../users/root.nix
    ../users/ops.nix
    {
      ops.keyFiles = [
        ../keys/tcurdt.pub
      ];
    }

    {
      users.users.root.password = "secret";
    }

  ];
}
