{ pkgs, ... }:
{
  # isNormalUser = true; # does not work for root

  shell = pkgs.bash;
  # shell = pkgs.zsh;

  # hashedPassword = "*"; # no password allowed, possible problem for root
}
