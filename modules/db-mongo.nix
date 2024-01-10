{ config, pkgs, ... }:
{
  services.mongodb = {
    enable = true;
  };
}
