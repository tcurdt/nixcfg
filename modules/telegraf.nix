{ config, pkgs, ... }:
{
  # https://github.com/influxdata/telegraf/blob/master/docs/CONFIGURATION.md
  services.telegraf = {
    enable = true;
    extraConfig = {
      global_tags = {
        # dc = "vafer.org";
      };
      agent = {
        interval = "30s";
        hostname = "\${TELEGRAF_INFLUX_HOST}";
      };
      inputs = {
        cpu = [{
          taginclude = { cpu = [ "cpu-total" ]; };
        }];
        # linux_cpu = {};
        mem = [{}];
        # swap = [{}]; # covered in mem
        kernel = [{}];
        system = [{}];
        # sysstat = [{}];
        processes = [{}];
        # procstat = [{}];
        # interrupts = [{}];
        conntrack = [{}];
        net = [{
          fieldexclude = [ "icmp*" "tcp*" "udp*" "ip*" ];
        }];
        netstat = [{}];
        disk = [{ mount_points = [ "/" ]; }];
        diskio = [{}];
        prometheus = [{
          urls = [ "http://127.0.0.1:2019/metrics" ]; # caddy
          tags = { service = "caddy"; };
          metric_version = 2;
          fieldinclude = [ "caddy_*" "process_*" ];
        }{
          urls = [ "http://127.0.0.1:8086/metrics" ]; # influxdb
          tags = { service = "influxdb"; };
          metric_version = 2;
          fieldinclude = [ "boltdb_*" "storage_*" ];
        }];
        # fail2ban = [{ # needs sudo configuration
        #   interval = 
        # }];
        # postgresql = [{
        #   interval = 
        #   address = "host=localhost user=postgres sslmode=disable";
        #   ignored_databases = [
        #     "postgres"
        #     "template0"
        #     "template1"
        #   ];
        # }];
        redis = [{
          servers = [ "tcp://127.0.0.1:6379" ];
          fieldinclude = [ "keyspace_*" "used_*" "tracking_*" "io_threaed_*" ];
        }];
        # x509_cert = [{
        #   interval = 
        #   sources = [
        #     tcp://api.vafer.org:443
        #     tcp://ntfy.vafer.org:443
        #   ];
        # }];
        # mqtt_consumer = [{
        #   servers = [ "tcp://foo:1883" ];
        #   topics = [ "sensor/" ];
        #   username = "";
        #   password = "";
        #   data_format = "influx";
        # }];
        # docker = [{
        #   endpoint = "unix:///var/run/docker.sock";
        # }];
        # exec = [{
        #   interval = 
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
        #   files = [ "/dev/null" ];
        # }];
        influxdb_v2 = [{
          urls = [ "http://127.0.0.1:8086" ];
          organization = "\${TELEGRAF_INFLUX_ORG}";
          bucket = "\${TELEGRAF_INFLUX_BUCKET}";
          token = "\${TELEGRAF_INFLUX_TOKEN}";
        }];
      };
    };
    environmentFiles = [ "/secrets/telegraf.env" ];
  };
}
