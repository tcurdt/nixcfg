{ config, pkgs, ... }:
{
  services.zerotierone = {
    enable = true;
    # port = 9993;
    joinNetworks = [
    ];
  };
}