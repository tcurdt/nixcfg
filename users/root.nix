{ config, pkgs, ... }:
{
  users.users = {
    root = import ./default.nix // {

      # openssh.authorizedKeys.keyFiles = [
      #   ../keys/tcurdt.pub
      # ];

      # password = "secret";
      # promptInitialPassword = true;
      # hashedPassword = "*"; # no password allowed
    };
  };

  # home-manager.users.root = import ../home/tcurdt.nix pkgs // {
  # };
}