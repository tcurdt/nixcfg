{ config, pkgs, ... }:
{
  services.thanos = {
    # compact = {};
    # downsample = {};
    # query = {};
    # query-frontend = {};
    # receive = {};
    # rule = {};
    # sidecar = {};
    # store = {};
  };

  environment.systemPackages = [
  ];
}
