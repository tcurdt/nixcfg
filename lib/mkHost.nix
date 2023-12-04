{ nixpkgs, myfoo, ... }:
{
  hardware,
  hostPlatform,
  hostName,
}: nixpkgs.lib.nixosSystem {

  modules = [
    ../hardware/${hardware}.nix
    myfoo.nixosModules

    {
      nixpkgs.hostPlatform = hostPlatform;
      networking.hostName = hostName;
      networking.domain = "utm";
      system.stateVersion = "23.05";
    }

  ];
}