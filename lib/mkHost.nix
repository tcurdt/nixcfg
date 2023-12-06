{ nixpkgs, sshhook, ... }:
#name:
{
  hardware,
  hostPlatform,
  hostName,
}: nixpkgs.lib.nixosSystem {

  modules = [
    ../hardware/${hardware}.nix
    # sshhook.nixosModules.default

    {
      nixpkgs.hostPlatform = hostPlatform;
      networking.hostName = hostName;
      networking.domain = "utm";
      system.stateVersion = "23.05";
    }

  ];
}