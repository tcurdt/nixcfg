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
    # settings = {
    #   http-bind-address = "127.0.0.1:8086";
    #   log-level = "error";
    # };
  };
  # environment.systemPackages = builtins.attrValues {
  #   inherit (pkgs)
  #     influxdb2-cli
  #     ;
  # };
}
