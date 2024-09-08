{ pkgs, ... }:
{

  services.home-assistant = {
    enable = true;
    # customComponents = [];
    # extraPackages = [];
    # customLovelaceModules = [];
    # lovelaceConfig = {};
    # lovelaceConfigWritable = false;
    config = {
      http = {
        server_host = [ "127.0.0.1" ];
        # server_port = 8123;
      };
      homeassistant = {
        name = "Home";
        time_zone = "UTC"; # Europe/Berlin";
        temperature_unit = "C";
        unit_system = "metric";
        # latitude = "";
        # longitude = "";
      };
      # frontend = {};
      # lovelace.mode = "yaml";
    };
  };

  environment.systemPackages = [
    # pkgs.home-assistant
    pkgs.home-assistant-cli
    # pkgs.homeassistant-satellite
  ];

}
