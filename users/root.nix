{ config, pkgs, ... }:
{
  users.users = {
    root = {
      openssh.authorizedKeys.keyFiles = [
        ./tcurdt.pub
      ];

      # password = "secret";
      # promptInitialPassword = true;
      # hashedPassword = "*"; # no password allowed
    };
  };
}