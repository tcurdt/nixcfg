{ pkgs, ... }:
{
  openssh.authorizedKeys.keyFiles = [
    ../keys/tcurdt.pub
  ];

  shell = pkgs.bash;
  # shell = pkgs.zsh;
}
