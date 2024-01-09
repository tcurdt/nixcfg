
{ config, pkgs, inputs, ... }:
let

  xxx = pkgs.writeScriptBin "xxx" ''
      #!${pkgs.bash}/bin/bash
      echo "hello $1"
      whoami
    '';


in {

  imports = [ ../scripts/bar.nix ];

  environment.systemPackages = with pkgs; [
    (import ../scripts/foo.nix { inherit pkgs; })
    xxx
    curl
  ];

  systemd.user.services.stage1 = {
    enable = true;

    description = "stage 1";

    script = "${pkgs.writeText "stage1" ''#!/usr/bin/env bash
      echo "stage1"
      whoami
      ''}";

    startAt = "minutely";

    # serviceConfig = {
    #   ExecStart = "${pkgs.pnmixer}/bin/pnmixer";
    # };

    # requires = [ "postgres" ];
    # after = [ "postgres" ];
  };

  systemd.user.services.stage2 = {
    enable = true;

    description = "stage 2";

    script = "${pkgs.writeText "stage2" ''#!/usr/bin/env bash
      echo "stage2"
      whoami
      ''}";

    # startAt = "minutely";

    # serviceConfig = {
    #   ExecStart = "${pkgs.pnmixer}/bin/pnmixer";
    # };

    # requires = [ "postgres" ];
    # after = [ "postgres" ];

    wantedBy = [ "stage1.service" ];
  };

  # systemd.user.services.backup = {
  #   enable = true;

  #   description = "backup databases";

  #   startAt = "daily";


  #   wantedBy = ["multi-user.target"];
  # };

  # systemd.tmpfiles.rules = [
  #   "d /var/www"
  #   "d /var/www/example.org 0750 example example"
  # ];

  # unitConfig = {
  #   ConditionPathExists = "/var/www/example.org/.env";
  #   ConditionDirectoryNotEmpty = "/var/www/example.org/vendor";
  # };

  # serviceConfig = {
  #   ExecStart = "${pkgs.pnmixer}/bin/pnmixer";
  # };
  # serviceConfig = {
  #   Type = "oneshot";
  #   User = "example";
  #   Group = "example";
  #   SyslogIdentifier = "example-laravel-scheduler";
  #   WorkingDirectory = "/var/www/example.org";
  #   ExecStart = "${php'}/bin/php artisan schedule:run -v";
  # };

}
