{ config, pkgs, ... }:
{

  services.caddy = {
    enable = true;

    # curl -k --resolve example.org:443:127.0.0.1 https://example.org
    virtualHosts."example.org" = {
      extraConfig = ''
        reverse_proxy http://127.0.0.1:8080
        # respond "OK"
        # tls internal
      '';
    };
  };

}
