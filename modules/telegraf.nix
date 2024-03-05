{ config, pkgs, ... }:
{
  services.telegraf = {
    enable = true;
    extraConfig = {
      global_tags = {
        dc = "vafer.org";
      };
      agent = {
        interval = "30s";
        hostname = "vafer.org";
        # round_interval = true
        # metric_batch_size = 1000
        # metric_buffer_limit = 10000
        # collection_jitter = "0s"
        # flush_interval = "10s"
        # flush_jitter = "0s"
        # precision = ""
        # omit_hostname = false
      };
      inputs = {
        internal = {
          namepass = [
            "internal_memstats"
            "internal_agent"
          ];
        };
        mem = {};
        cpu = {};
        disk = {
          mount_points = [
            "/"
          ];
        };
        prometheus = {
          urls = [
          ];
          metric_version = 2;
          fieldinclude = [
            "process_resident_memory_bytes"
          ];
        };
        # mqtt_consumer = {
        #   servers = ["tcp://foo:1883"];
        #   topics = ["sensor/"];
        #   username = "";
        #   password = "";
        #   data_format = "influx";
        # };
        # docker = {
        #   endpoint = "unix:///var/run/docker.sock";
        # };
        # exec = {
        #   commands = [
        #     "/tmp/test.sh"
        #     "/usr/bin/mycollector --foo=bar"
        #     "/tmp/collect_*.sh"
        #   ];
        #   environment = [];
        #   timeout = "5s";
        #   name_suffix = "_mycollector";
        # };
      };
      outputs = {
        file = {
          files = [
            "/dev/null"
          ];
        };
        # influxdb = {
        #   database = "telegraf";
        #   urls = [
        #     "http://localhost:8086"
        #   ];
        # };
        # influxdb_v2 = {
        #   urls = [
        #     "http://localhost:8086"
        #   ];
        #   organization = "vafer.org";
        #   bucket = "telegraf";
        #   token = "SECRET";
        # };
      };
    };
    environmentFiles = [];
  };
}
