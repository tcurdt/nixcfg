{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
let

  inherit (lib) mkOption;
  # inherit (lib.types) listOf str;

  cfg = config.ops;

in
{

  options = {
    ops = {
      keyFiles = mkOption {
        default = [ ];
        description = "...";
        # type = listOf str; # or whatever type these actually are
      };
      home-manager = mkOption {
        default = ../home/tcurdt.nix;
        description = "...";
      };
    };
  };

  imports = [ inputs.home-manager.nixosModules.default ];

  config = {

    # Optimize Home Manager
    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    users.users.ops = (import ./default.nix pkgs) // {

      openssh.authorizedKeys.keyFiles = cfg.keyFiles;

      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
      ];
      hashedPassword = "*"; # no password allowed

    };

    home-manager.users.ops = (import cfg.home-manager pkgs) // {
      # home.shellAliases = {
      #   foo = "eza";
      # };
      # home.stateVersion = "23.11";
    };
  };
}
