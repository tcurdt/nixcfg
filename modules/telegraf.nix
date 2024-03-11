{ config, pkgs, ... }:
{
  services.telegraf = {
    enable = true;
    extraConfig = {
      global_tags = {
        # dc = "vafer.org";
      };
      agent = {
        interval = "30s";
        hostname = "\${TELEGRAF_INFLUX_HOST}";
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
        # internal = {
        #   namepass = [
        #     "internal_memstats"
        #     "internal_agent"
        #   ];
        # };
        cpu = [{}];
        # linux_cpu = {};
        mem = [{}];
        swap = [{}];
        kernel = [{}];
        system = [{}];
        # sysstat = [{}];
        processes = [{}];
        # procstat = [{}];
        # interrupts = [{}];
        conntrack = [{}];
        net = [{}];
        netstat = [{}];
        disk = [{
          mount_points = [
            "/"
          ];
        }];
        diskio = [{}];
        prometheus = [{
          urls = [
            # "http://127.0.0.1:8086/metrics"
          ];
          # metric_version = 2;
          # fieldinclude = [
          #   "process_resident_memory_bytes"
          # ];
        }];
        # fail2ban = [{}]; # broken
        #postgresql = [{
        #  ignored_databases = [
        #    "postgres"
        #    "template0"
        #    "template1"
        #  ];
        #}];
        redis = [{
          servers = [ "tcp://127.0.0.1:6379" ];
        }];
        # x509_cert = [{
        #   sources = [
        #     tcp://api.vafer.org:443
        #     tcp://ntfy.vafer.org:443
        #   ];
        # }];
        # mqtt_consumer = [{
        #   servers = ["tcp://foo:1883"];
        #   topics = ["sensor/"];
        #   username = "";
        #   password = "";
        #   data_format = "influx";
        # }];
        # docker = [{
        #   endpoint = "unix:///var/run/docker.sock";
        # }];
        # exec = [{
        #   commands = [
        #     "/tmp/test.sh"
        #     "/usr/bin/mycollector --foo=bar"
        #     "/tmp/collect_*.sh"
        #   ];
        #   environment = [];
        #   timeout = "5s";
        #   name_suffix = "_mycollector";
        # }];
      };
      outputs = {
        # file = [{
        #   files = [
        #     "/dev/null"
        #   ];
        # }];
        influxdb_v2 = [{
          urls = [
            "http://127.0.0.1:8086"
          ];
          organization = "\${TELEGRAF_INFLUX_ORG}";
          bucket = "\${TELEGRAF_INFLUX_BUCKET}";
          token = "\${TELEGRAF_INFLUX_TOKEN}";
        }];
      };
    };
    environmentFiles = [ "/secrets/telegraf.env" ];
  };
}
