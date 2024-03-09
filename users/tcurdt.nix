{ config, pkgs, inputs, ... }:
{

  imports = [ inputs.home-manager.nixosModules.default ];

  users.users.tcurdt = (import ./default.nix pkgs) // {

    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];

    hashedPassword = "*"; # no password allowed

  };

  home-manager.users.tcurdt = (import ../home/tcurdt.nix pkgs) // {
  };

}