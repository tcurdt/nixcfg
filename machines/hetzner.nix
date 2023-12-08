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

  hardware = "hetzner";
  hostPlatform = "x86_64-linux";
  hostName = "nixos";

in nixpkgs.lib.nixosSystem {

  modules = [
    ../hardware/${hardware}.nix
    ../modules/server.nix
    ../modules/k3s.nix

    {
      nixpkgs.hostPlatform = hostPlatform;
      networking.hostName = hostName;
      networking.domain = "nixos";
      system.stateVersion = "23.11";
    }

  ];
}