{ config, pkgs, ... }:
{
  services.redis = {
    servers = {
      foo = {
        enable = true;
        bind = "127.0.0.1";
        port = 6370;
        # unixSocket = "/var/run/redis.sock";
        # appendOnly = true;
        # extraConfig = "";
      };
    };
  };
}
