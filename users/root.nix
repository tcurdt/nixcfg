{ config, pkgs, ... }:
{
  users.users = {
    root = {
      # shell = pkgs.nushell;
      openssh.authorizedKeys.keyFiles = [
        ./tcurdt.pub
      ];
      # openssh.authorizedKeys.keys = [ (builtins.readFile ./tcurdt.pub) ];

      # promptInitialPassword = true;
      # password = "secret";
      # hashedPassword = "*"; # no password allowed
    };
  };
}