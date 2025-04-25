{
  # pkgs,
  ...
}:
{
  # sudo -u postgres psql
  # \l
  services.postgresql = {
    enable = true;
    # settings = {
    #   listen_addresses = pkgs.lib.mkForce "0.0.0.0";
    # };
    identMap = ''
      superuser_map      root      postgres
      superuser_map      postgres  postgres
      superuser_map      /^(.*)$   \1
    '';
    # ensureDatabases = [
    #   "bluesky"
    # ];
    ensureUsers = [
      {
        name = "postgres";
        # ensureDBOwnership = true;
        # ensurePermissions = {
        #   "bluesky.*" = "ALL PRIVILEGES";
        # };
      }
    ];
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

  # https://github.com/NixOS/nixpkgs/blob/2230a20f2b5a14f2db3d7f13a2dc3c22517e790b/nixos/modules/services/databases/pgbouncer.nix
  # services.pgbouncer = {
  #   enabled = true;
  #   # listenAddress = "127.0.0.1";
  #   # maxClientConn = 100;
  #   # defaultPoolSize = 20;
  #   # maxDbConnections = 0;
  #   # maxUserConnections = 0;
  #   # databases = {};
  #   # users = {};
  #   # peers = {};
  #   # authType = "trust";
  #   # authFile = "/secrets"
  #   # authUser
  #   # authQuery
  #   # authDbname
  # };

}
