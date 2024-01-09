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

  users.users = {

    tcurdt = {
      # shell = pkgs.nushell;
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      # openssh.authorizedKeys.keyFiles = [ ./ssh_pub_tcurdt ];
      # openssh.authorizedKeys.keyFiles = [ (fetchKeys "tcurdt") ]; # github
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2CLOzyXcqk4uo6hCkkQAtozJCebA/Dh4ps6Vr2GVNTC7j7nF5HuT+penp/Y9yPAuTorxunmFn7BPwZggzopEgfmUQ4gf0CysTwPQMxt9yK3ZHpxgkGoJyR0n91OdPAbukqwWZHYxGGxvHNoap59kobUrIImIa97gKxW+IVKwL9iyWXyqonRpue1mf1N1ioDtPLS1yvzf4Jo7aDND+4I/34X6436VwZItUwzvhFcuNh/gQmvKpmVjD+ED2Q/yRtGq0EzsPfrDZg1ZKV5V1cT/3w7QtYFcZB9+AQxq88jVRcIlf3K45kpmbsWVfBFN6ND+NeZK1mlp/3TV8C6dNVqU2w== tcurdt@shodan.local"
      ];
      packages = with pkgs; [
        tmux
        htop
      ];
      hashedPassword = "*"; # no password allowed
    };

    root = {
      # shell = pkgs.nushell;
      # openssh.authorizedKeys.keyFiles = [ ./ssh_pub_tcurdt ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2CLOzyXcqk4uo6hCkkQAtozJCebA/Dh4ps6Vr2GVNTC7j7nF5HuT+penp/Y9yPAuTorxunmFn7BPwZggzopEgfmUQ4gf0CysTwPQMxt9yK3ZHpxgkGoJyR0n91OdPAbukqwWZHYxGGxvHNoap59kobUrIImIa97gKxW+IVKwL9iyWXyqonRpue1mf1N1ioDtPLS1yvzf4Jo7aDND+4I/34X6436VwZItUwzvhFcuNh/gQmvKpmVjD+ED2Q/yRtGq0EzsPfrDZg1ZKV5V1cT/3w7QtYFcZB9+AQxq88jVRcIlf3K45kpmbsWVfBFN6ND+NeZK1mlp/3TV8C6dNVqU2w== tcurdt@shodan.local"
      ];
      # promptInitialPassword = true;
      # password = "secret";
      hashedPassword = "*"; # no password allowed
    };

  };
}