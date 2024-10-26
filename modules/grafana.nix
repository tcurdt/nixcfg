{ pkgs, ... }:
{
  services.grafana = {
    enable = true;
    settings = {
      analytics.reporting_enabled = false;
      security = {
        admin_user = "admin";
        admin_email = "admin@localhost";
        admin_password = "admin";
      };
    };
    # dataDir = "";
    # declarativePlugins = [
    #   pkgs.grafanaPlugins.grafana-piechart-panel
    # ];
    provision = {
      # datasources = [
      #   {
      #     name = "loki";
      #     type = "loki";
      #     url = "127.0.0.1:3100";
      #   }
      # ];
      # notifiers = {};
      # dashboards = {
      #   path = "";
      # };
    };
  };

  environment.systemPackages = [ ];
}
