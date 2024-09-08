
{ config, pkgs, lib, ... }:
let

  # backup read PRIVATE
  # backup write PUBLIC
  backupScript = pkgs.writeScriptBin "backup" ''
      #!${pkgs.bash}/bin/bash
      set -e

      handle_error() {
        local exit_code="$?"
        echo "error occurred in script at line $1 with exit code $exit_code" >&2
        echo "backup failed"
        exit $exit_code
      }

      trap 'handle_error $LINENO' ERR

      backup_write() {
        echo "backup write start"

        KEY=$(cat /secrets/backup-key)
        /run/wrappers/bin/sudo -u postgres ${pkgs.postgresql}/bin/pg_dumpall | ${lib.getExe' pkgs.bzip2 "bzip2"} | ${lib.getExe pkgs.age} -r "$KEY" > /tmp/sql.bzip2.age

        stat -c "backup size: %s" /tmp/sql.bzip2.age

        ${lib.getExe pkgs.rclone} copy \
          --dry-run \
          --contimeout=10s \
          --retries=2 \
          --error-on-no-transfer \
          --no-traverse \
          --immutable \
          --config /secrets/backup-bucket \
          "/tmp/sql.bzip2.age" \
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

    # RuntimeDirectory = "myService";
    # RootDirectory = "/run/myService";

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
