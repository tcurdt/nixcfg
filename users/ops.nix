{ config, pkgs, lib, inputs, ... }: let

  inherit (lib) mkOption;
  # inherit (lib.types) listOf str;

  cfg = config.ops;

in {

  options = {
    ops = {
      keyFiles = mkOption {
        default = [];
        description = "...";
        # type = listOf str; # or whatever type these actually are
      };
    };
  };

  imports = [ inputs.home-manager.nixosModules.default ];

  config = {

    users.users.ops = (import ./default.nix pkgs) // {

      isNormalUser = true;
      openssh.authorizedKeys.keyFiles = cfg.keyFiles;

    };

    home-manager.users.ops = (import ../home/tcurdt.nix pkgs) // {
    };
  };
}