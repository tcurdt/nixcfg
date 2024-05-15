{ config, pkgs, ... }:
{
  services.prometheus = {
    enable = true;
    # globalConfig = {
    #   scrape_interval = "10s";
    # };
    # scrapeConfigs = [];
    exporters = {
      node = {
        enable = true;
        # enabledCollectors = [ "systemd" ];
      };
      # systemd = {};
      # postgres = {};
      # redis = {};
    };
    pushgateway = {
      enable = true;
    };
  };

  environment.systemPackages = [
  ];
}