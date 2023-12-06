# #{ config, nodes, self, ... }:
# #{ config, pkgs, ... }:
# { nixpkgs, ... }:
# {
#   # nixpkgs.lib.nixosSystem {
#     networking.hostName = "nixos";
#     networking.domain = "utm";
#     #system.stateVersion = "23.05";
#     system = "aarch64-linux";
#   # };
# }

{ nixpkgs, ... }: let

  hardware = "utm";
  hostPlatform = "aarch64-linux";
  hostName = "foo";

in nixpkgs.lib.nixosSystem {

  modules = [
    ../hardware/${hardware}.nix
    ../modules/server.nix
    ../modules/k3s.nix

    {
      nixpkgs.hostPlatform = hostPlatform;
      networking.hostName = hostName;
      networking.domain = "utm";
      system.stateVersion = "23.05";
    }

  ];
}