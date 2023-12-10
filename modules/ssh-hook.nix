{ config, pkgs, inputs, ... }:

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
    };

    security.sudo = {
      enable = true;
      extraRules = [{
        commands = [
          {
            command = "${hookScript}/bin/hook";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ]; # FIXME only the user "foo"
      }];
    };

}
