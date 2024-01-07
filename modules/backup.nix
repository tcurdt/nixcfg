
{ config, pkgs, inputs, ... }:
{
  environment.systemPackages = with pkgs; [
    (import ../scripts/foo.nix { inherit pkgs; })
    curl
  ];

  # systemd.user.services.backup = {
  #   enable = true;

  #   description = "backup persistence";

  #   startAt = "minutely";

  #   # serviceConfig = {
  #   #   ExecStart = "${pkgs.pnmixer}/bin/pnmixer";
  #   # };

  #   requires = [ "postgres" ];
  #   after = [ "postgres" ];
  # };


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
