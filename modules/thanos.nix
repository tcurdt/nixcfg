{ config, pkgs, ... }:
{
  services.thanos = {
    sidecar = {};
    store = {};
    query = {};
    query-frontend = {};
    rule = {};
    compact = {};
    downsample = {};
    receive = {};

    # log = "error";
    # tracing = {};
    # common = {};
    # objstore = {};
  };

  environment.systemPackages = [
  ];
}
