{ lib, ... }:
mkHostAttrs: lib.mkDefault {

  hardware = lib.mkOption {
    default = "utm";
    type = lib.types.str;
    description = "specify hardware config";
  };

  hostPlatform = lib.mkOption {
    default = "aarch64-linux";
    type = lib.types.str;
    description = "specify host platform";
  };

  hostName = lib.mkOption {
    default = "nixos";
    type = lib.types.str;
    description = "specify host name";
  };

}

{ nixpkgs, ... }:
#name:
{
  hardware,
  hostPlatform,
  hostName,
}:

let
  hardware = mkHostAttrs.hardware;
  hostPlatform = mkHostAttrs.hostPlatform;
  hostName = mkHostAttrs.hostName;
in
nixpkgs.lib.nixosSystem {

  modules = [
    ../hardware/${hardware}.nix

    {
      nixpkgs.hostPlatform = hostPlatform;
      networking.hostName = hostName;
      networking.domain = "utm";
      system.stateVersion = "23.05";
    }
  ];
}
