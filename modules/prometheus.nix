{
  # pkgs,
  ...
}:
{
  services.prometheus = {
    enable = true;
    listenAddress = "127.0.0.1"; # "0.0.0.0";
    globalConfig = {
      scrape_interval = "10s";
    };
    scrapeConfigs = [

      {
        job_name = "prometheus";
        static_configs = [ { targets = [ "127.0.0.1:9090" ]; } ];
        metric_relabel_configs = [
          {
            source_labels = [ "__name__" ];
            regex = "^(prometheus_.*|up)";
            action = "keep";
          }
        ];
      }

      {
        job_name = "push";
        static_configs = [ { targets = [ "127.0.0.1:9091" ]; } ];
        metric_relabel_configs = [
          {
            source_labels = [ "__name__" ];
            regex = "up";
            action = "keep";
          }
        ];
      }

      {
        job_name = "caddy";
        static_configs = [ { targets = [ "127.0.0.1:2019" ]; } ];
        metric_relabel_configs = [
          {
            source_labels = [ "__name__" ];
            regex = "^(caddy_.*|up)";
            action = "keep";
          }
        ];
      }

      {
        job_name = "node";
        static_configs = [ { targets = [ "127.0.0.1:9100" ]; } ];
        metric_relabel_configs = [
          {
            source_labels = [ "__name__" ];
            regex = "^(node_.*|process_.*|up)";
            action = "keep";
          }
        ];
      }
    ];

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

  environment.systemPackages = [ ];
}
