{ pkgs, ... }:
{
  # openssh.authorizedKeys.keyFiles = [
  #   ../keys/tcurdt.pub
  # ];

  # isNormalUser = true; # does not work for root

  shell = pkgs.bash;
  # shell = pkgs.zsh;

  # hashedPassword = "*"; # no password allowed
}
