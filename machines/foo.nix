#{ config, nodes, self, ... }:
#{ config, pkgs, ... }:
{ nixpkgs, ... }:
{
  # nixpkgs.lib.nixosSystem {
    networking.hostName = "nixos";
    networking.domain = "utm";
    #system.stateVersion = "23.05";
    system = "aarch64-linux";
  # };
}
