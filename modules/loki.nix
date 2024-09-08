{ pkgs, ... }:
{
  services.loki = {
    enable = true;
    configuration = {
      analytics.reporting_enabled = false;
      auth_enabled = false;

      server = {
        http_listen_address = "127.0.0.1"; # "0.0.0.0";
        http_listen_port = 3100;
        grpc_listen_address = "127.0.0.1"; # "0.0.0.0";
        grpc_listen_port = 9095;
        log_level = "error";
        # log_format = "json";
      };

      common = {
        instance_addr = "127.0.0.1"; # "0.0.0.0";
        replication_factor = 1;
        ring = {
          kvstore = {
            store = "inmemory";
          };
        };
        path_prefix = "/var/lib/loki";
        storage = {
          filesystem = {
            chunks_directory = "/var/lib/loki/chunks";
            rules_directory = "/var/lib/loki/rules";
          };
        };
      };

      query_range = {
        results_cache = {
          cache = {
            embedded_cache = {
              enabled = true;
              max_size_mb = 100;
            };
          };
        };
      };

      schema_config = {
        configs = [
          {
            from = "2024-05-01";
            store = "tsdb";
            object_store = "filesystem";
            schema = "v13";
            index = {
              prefix = "index_";
              period = "24h";
            };
          }
        ];
      };

      ruler = {
        # alertmanager_url = "http://localhost:9093";
      };

      frontend = {
        # encoding = "protobuf";
      };

    };
  };

  environment.systemPackages = [
  ];
}
