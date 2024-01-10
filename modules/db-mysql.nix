{ config, pkgs, ... }:
{
  # sudo -u mysql mysql
  # show databases;
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    settings.mysqld = {
      bind-address = "127.0.0.1";
    };
    # ensureDatabases = [
    #   "bluesky"
    # ];
    ensureUsers = [{
      name = "root";
      # ensureDBOwnership = true;
      # ensurePermissions = {
      #   "bluesky.*" = "ALL PRIVILEGES";
      # };
    }];
    # initialScript = pkgs.writeText "setup.sql" ''
    #   ALTER USER 'root'@'localhost' IDENTIFIED BY 'secret';
    #   GRANT ALL PRIVILEGES ON bluesky.* TO 'root'@'localhost';
    # '';
    # CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED WITH mysql_native_password;
    #     ensurePermissions = {
    #       "*.*" = "SELECT, LOCK TABLES";
  };
}
