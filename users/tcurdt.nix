{ config, pkgs, ... }:
{
  users.users = {
    tcurdt = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      openssh.authorizedKeys.keyFiles = [ ./tcurdt.pub ];

      # shell = pkgs.nushell;
      packages = with pkgs; [
        tmux
        htop
      ];

      hashedPassword = "*"; # no password allowed
    };
  };
}