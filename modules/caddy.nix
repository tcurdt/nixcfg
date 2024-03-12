{ config, pkgs, ... }:
{

  services.caddy = {
    enable = true;

    # curl -k --resolve whoami.vafer.work:443:127.0.0.1 https://whoami.vafer.work
    # virtualHosts."whoami.vafer.work" = {
    #   extraConfig = ''
    #     reverse_proxy http://127.0.0.1:8080
    #   '';
    # };
  };

}
