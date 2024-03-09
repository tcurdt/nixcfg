{ config, pkgs, ... }:
{
  # https://docs.influxdata.com/influxdb/v2/reference/config-options/
  services.influxdb2 = {
    enable = true;
    # provision = {
    #   bucket = "";
    #   username = "";
    #   passwordFile = "";
    #   tokenFile = "";
    # };
    # auths = {
    #   tokeFile = "";
    # };
    settings = {
      http-bind-address = "127.0.0.1:8086";
      log-level = "error";
    };
  };

  environment.systemPackages = [
    pkgs.influxdb2-cli
  ];
}

# https://docs.influxdata.com/influxdb/v2/install/#set-up-influxdb

# open http://localhost:8086

# influx setup \
#   --username USERNAME \
#   --password PASSWORD \
#   --token TOKEN \
#   --org ORGANIZATION_NAME \
#   --bucket BUCKET_NAME \
#   --force

# influx auth create \
#   --all-access \
#   --host http://localhost:8086 \
#   --org <YOUR_INFLUXDB_ORG_NAME> \
#   --token <YOUR_INFLUXDB_OPERATOR_TOKEN>

# influx config create \
#   --config-name default \
#   --host-url http://localhost:8086 \
#   --org ORG \
#   --token API_TOKEN \
#   --active