{ config, pkgs, ... }:
{
  users.users = {
    root = {
      openssh.authorizedKeys.keyFiles = [
        ./tcurdt.pub
      ];

      # promptInitialPassword = true;
      # password = "secret";
      # hashedPassword = "*"; # no password allowed
    };
  };
}