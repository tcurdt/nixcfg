{ config, pkgs, ... }:
{

  programs.bash = {
    # shellInit =
    # loginShellInit =
    interactiveShellInit = builtins.readFile ../home/bash.sh;
    shellAliases = {
      la = "ls -la";
    };
  };

  # environment.interactiveShellInit = builtins.readFile ../home/bash.sh;
  environment.shellAliases = {
    ll = "ls -la";
  };

  security.sudo.wheelNeedsPassword = false;
  security.sudo.execWheelOnly = true;
  # security.sudo = {
  #   enable = true;
  #   extraRules = [{
  #     commands = [
  #       {
  #         command = "${pkgs.systemd}/bin/systemctl suspend";
  #         options = [ "NOPASSWD" ];
  #       }
  #       {
  #         command = "${pkgs.systemd}/bin/reboot";
  #         options = [ "NOPASSWD" ];
  #       }
  #       {
  #         command = "${pkgs.systemd}/bin/poweroff";
  #         options = [ "NOPASSWD" ];
  #       }
  #     ];
  #     groups = [ "wheel" ];
  #   }];
  # };

  users.mutableUsers = false;

  # nix.settings = {
  #   trusted-users = [ "@wheel" ];
  #   allowed-users = [ "@wheel" ];
  # };
  # nix.allowedUsers = [ "@wheel" ];

  # users.users = {
  #   "*".hashedPassword = "*"; # no passwords
  # };
}
