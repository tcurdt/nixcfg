{ config, pkgs, lib, inputs, ... }:

	let

    hookScript = pkgs.writeScriptBin "hook" ''
      #!${pkgs.bash}/bin/bash
      echo "hello $1"
      whoami
    '';

    sshScript = pkgs.writeScriptBin "ssh-hook" ''
      #!${pkgs.bash}/bin/bash
      set -eu
      set -o pipefail
      [[ -z "''${SSH_ORIGINAL_COMMAND:-}" ]] && exit 1
      case "''${SSH_ORIGINAL_COMMAND}" in
        "hook"*)
          exec sudo ${hookScript}/bin/hook
          ;;
        *)
          echo "invalid command"
          exit 1
          ;;
      esac
    '';

  in {

    services.openssh.enable = true;

    services.openssh.extraConfig = ''
      Match User hook
        PasswordAuthentication no
        AllowAgentForwarding no
        AllowTcpForwarding no
        X11Forwarding no
        ForceCommand ${sshScript}/bin/ssh-hook
    '';

    users.users.hook = {
      isNormalUser = true;
      packages = [ hookScript ];
    };

    security.sudo = {
      enable = true;
      extraRules = [{
        commands = [
          {
            #command = "${hookScript}/bin/hook";
            command = lib.getExe hookScript;
            options = [ "NOPASSWD" ];
          }
          {
            command = "/etc/profiles/per-user/hook/bin/hook";
            options = [ "NOPASSWD" ];
          }
        ];
        users = [ "hook" ];
      }];
    };

}
