{ config, pkgs, ... }:
{
  services.loki = {
    enable = true;
    configuration = {
      analytics.reporting_enabled = false;
      auth_enabled = false;

      server = {
        http_listen_port = 3100;
        grpc_listen_port = 9096;
      };

      common = {
        instance_addr = "127.0.0.1";
        path_prefix = "/tmp/loki";
        storage = {
          filesystem = {
            chunks_directory = "/tmp/loki/chunks";
            rules_directory = "/tmp/loki/rules";
          };
        };
        replication_factor = 1;
        ring = {
          kvstore = {
            store = "inmemory";
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
            from = "2020-10-24";
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
        alertmanager_url = "http://localhost:9093";
      };

      frontend = {
        encoding = "protobuf";
      };

    };
  };

  environment.systemPackages = [
  ];
}
