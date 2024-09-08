{ pkgs, ... }:
{

  # programs.bash.enable = true; # always installed
  programs.zsh.enable = true;

  # programs.bash = {
  #   shellInit =
  #   loginShellInit =
  #   interactiveShellInit = builtins.readFile ../shells/bash.sh;
  #   shellAliases =
  # };

  # environment.interactiveShellInit = builtins.readFile ../shells/bash.sh;
  # environment.shellAliases = {
  # };

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

  # home-manager = {
  #   useGlobalPkgs = true;
  #   useUserPkgs = true;
  # };

  # nix.settings = {
  #   trusted-users = [ "@wheel" ];
  #   allowed-users = [ "@wheel" ];
  # };
  # nix.allowedUsers = [ "@wheel" ];

}
