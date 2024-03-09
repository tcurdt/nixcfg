{ pkgs, ... }:
{
  openssh.authorizedKeys.keyFiles = [
    ../keys/tcurdt.pub
  ];

  programs.bash.enable = true;
  programs.zsh.enable = true;

  # shell = pkgs.bash;
  shell = pkgs.zsh;
}
