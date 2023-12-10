{ config, pkgs, inputs, ... }:

	let

    deployScript = pkgs.writeScriptBin "deploy" ''
      #!/usr/bin/env bash
      echo "hello"
      whoami
      sudo whoami
    '';

    rebuildScript = pkgs.writeScriptBin "rebuild" ''
      #!/usr/bin/env bash
      echo "hello"
      whoami
    '';

    # hookScript = pkgs.writeScriptBin "hook" ''
    #   #!/usr/bin/env bash
    #   set -eu
    #   set -o pipefail
    #   [[ -z "${SSH_ORIGINAL_COMMAND:-}" ]] && exit 1
    #   case "${SSH_ORIGINAL_COMMAND}" in
    #     "deploy"*)
    #       exec <module>/bin/deploy
    #       ;;
    #     *)
    #       echo "invalid command"
    #       exit 1
    #       ;;
    #   esac
    # '';

  in {

    services.openssh.enable = true;

    # services.openssh.extraConfig = ''
    #   Match User hook
    #     PasswordAuthentication no
    #     AllowAgentForwarding no
    #     AllowTcpForwarding no
    #     X11Forwarding no
    #     ForceCommand <module>/bin/hook
    # '';

    nixosModules.default = {

      users.users.hook = {
        isNormalUser = true;
      };

      security.sudo = {
        enable = true;
        extraRules = [{
          commands = [
            {
              command = "/run/current-system/sw/bin/whoami";
              options = [ "NOPASSWD" ];
            }
            {
              command = "nixos-rebuild build --flake .#utm";
              options = [ "NOPASSWD" ];
            }
          ];
          groups = [ "wheel" ]; # FIXME only the user "foo"
        }];
      };

    };
}