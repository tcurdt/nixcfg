
{ config, pkgs, lib, inputs, ... }:
let

  # backup read PRIVATE
  # backup write PUBLIC
  backupScript = pkgs.writeScriptBin "backup" ''
      #!${pkgs.bash}/bin/bash

      handle_error() {
        local exit_code="$?"
        echo "error occurred in script at line $1 with exit code $exit_code" >&2
        echo "backup failed"
        exit $exit_code
      }

      trap 'handle_error $LINENO' ERR

      backup_write() {
        echo "backup write start"

        sudo -u postgres pg_dumpall | bzip2 | age -r $(/secrets/backup-key) > sql.bzip2.age

        rclone copy \
          -vv \
          --no-traverse \
          --immutable \
          --config /secrets/backup-bucket \
          "sql.bzip2.age" \
          "backup:bucket/path"

        echo "backup write success"
      }

      backup_read() {
        echo "backup read start"
        echo "backup read success"
      }

      if [ "$1" = "write" ]; then
          backup_write $2
      elif [ "$1" = "read" ]; then
          backup_read $2
      else
          echo "Usage: $0 [write PUBLIC|read PRIVATE]"
          exit 1
      fi
    '';


in {

  imports = [ ../scripts/bar.nix ];

  environment.systemPackages = [
    pkgs.curl
    pkgs.age
    pkgs.rclone

    backupScript
    # (import ../scripts/foo.nix { inherit pkgs; })
  ];

  # journalctl --since now -f -u stage1 -u stage2
  systemd.services.backup = {
    enable = true;

    description = "backup";

    # sudo -u postgres psql
    # sudo -u postgres pg_dumpall
    script = "${pkgs.writeScript "backup" ''
      #!${pkgs.bash}/bin/bash
      ${lib.getExe backupScript} write $(cat /secrets/backup-key)
    ''}";

    serviceConfig.Type = "oneshot";
    startAt = "minutely";

    # onSuccess = [ "stage2.service" ];
  };

  systemd.timers.backup = {
    wantedBy = [ "timers.target" ];
    partOf = [ "backup.service" ];
    timerConfig.OnCalendar = [
      "*-*-* 01:00:00" # daily at 1am
    ];
  };


  # systemd.services.stage2 = {
  #   enable = true;

  #   description = "stage 2";

  #   script = "${pkgs.writeScript "stage2" ''
  #     #!${pkgs.bash}/bin/bash
  #     echo "stage2 start"
  #     whoami
  #     sleep 1
  #     echo "stage2 stop"
  #     ''}";

  #   serviceConfig.Type = "oneshot";
  #   #after = [ "stage1.service" ];
  #   #wantedBy = [ "stage1.service" ];
  # };

  # systemd.tmpfiles.rules = [
  #   "d /var/www"
  #   "d /var/www/example.org 0750 example example"
  # ];

}
