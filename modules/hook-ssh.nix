{ config, pkgs, lib, inputs, ... }:

	let

    hookScript = pkgs.writeScriptBin "hook" ''
      #!${pkgs.bash}/bin/bash
      echo "hello $1"
      whoami
    '';

    sshScript = pkgs.writeScriptBin "ssh-forced-command" ''
      #!${pkgs.bash}/bin/bash
      set -eu
      set -o pipefail
      [[ -z "''${SSH_ORIGINAL_COMMAND:-}" ]] && { echo "Missing command"; exit 1; }
      IFS=' ' read -r -a ARGS <<< "${SSH_ORIGINAL_COMMAND}"
      CMD="${ARGS[0]}"
      ARG="${ARGS[1]}"
      [[ "$CMD" != "hook" ]] && { echo "Invalid command"; exit 2; }
      exec sudo ${lib.getExe hookScript} "$ARG"
    '';

  in {

    services.openssh.enable = true;

    services.openssh.extraConfig = ''
      Match User hook
        PasswordAuthentication no
        AllowAgentForwarding no
        AllowTcpForwarding no
        X11Forwarding no
        ForceCommand ${lib.getExe sshScript}
    '';

    users.users.hook = {
      isNormalUser = true;
      packages = [ sshScript hookScript ];
      openssh.authorizedKeys.keyFiles = [ ../users/hook.pub ];
    };

    security.sudo = {
      enable = true;
      extraRules = [{
        commands = [
          {
            command = lib.getExe hookScript;
            options = [ "NOPASSWD" ];
          }
          # {
          #   command = "/etc/profiles/per-user/hook/bin/hook";
          #   options = [ "NOPASSWD" ];
          # }
        ];
        users = [ "hook" ];
      }];
    };

}
