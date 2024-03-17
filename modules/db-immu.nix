{ config, pkgs, ... }:
{
  services.immudb = {
    enable = true;
    settings = {
    };
  };

  environment.systemPackages = [
  ];
}