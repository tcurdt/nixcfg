{ config, pkgs, ... }:
{
  # sudo -u postgres psql
  # \l
  services.postgresql = {
    enable = true;
    # ensureDatabases = [
    #   "bluesky"
    # ];
    ensureUsers = [{
      name = "postgres";
      # ensureDBOwnership = true;
      # ensurePermissions = {
      #   "bluesky.*" = "ALL PRIVILEGES";
      # };
    }];
    # initialScript = pkgs.writeText "setup.sql" ''
    #   ALTER USER postgres PASSWORD 'secret';
    #   GRANT ALL PRIVILEGES ON DATABASE "bluesky" to postgres;
    # '';
    # authentication = pkgs.lib.mkOverride 10 ''
    #   #type database  DBuser auth-method
    #   local all       all    trust
    # '';
    # enableTCPIP = true;
  };
}
