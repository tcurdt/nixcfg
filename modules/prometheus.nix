{ config, pkgs, ... }:
{
  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1"; # "0.0.0.0"
    # globalConfig = {
    #   scrape_interval = "10s";
    # };
    # scrapeConfigs = [
    #   {
    #     job_name = "";
    #     static_configs = [
    #       {
    #         targets = [ "localhost:${toString config.services.prometheus.exporters.node.port}" ];
    #       }
    #     ];
    #   }
    # ];
    exporters = {
      node = {
        enable = true;
        listenAddress = "127.0.0.1";
        enabledCollectors = [
          "disable-defaults"
          "cpu"
          "diskstats"
          "entropy"
          "filesystem"
          "loadavg"
          # "textfile"
          # "systemd"
        ];
        # disabledCollectors = [];
      };
      # systemd = {};
      # postgres = {};
      # redis = {};
    };
    pushgateway = {
      enable = true;
      web.listen-address = "127.0.0.1:9091";
    };
  };

  environment.systemPackages = [
  ];
}
