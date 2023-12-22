{ nixpkgs, impermanence, ... }@inputs: let

  hardware = "hetzner";
  hostPlatform = "x86_64-linux";
  hostName = "nixos";

in nixpkgs.lib.nixosSystem {

  specialArgs = { inherit inputs; };

  modules = [
    ../hardware/${hardware}.nix
    ../modules/server.nix
    ../modules/k3s.nix
    ../modules/users.nix

    {
      nixpkgs.hostPlatform = hostPlatform;
      networking.hostName = hostName;
      networking.domain = "nixos";
      system.stateVersion = "23.11";
    }

  ];
}