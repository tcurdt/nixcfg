{ config, pkgs, ... }:
{

  # environment.systemPackages = with pkgs; [
  #   nss.tools
  # ];

  services.caddy = {
    enable = true;

    # curl localhost -i -H "Host: example.org"
    # reverse_proxy http://127.0.0.1:8080
    virtualHosts."example.org" = {
      extraConfig = ''
        respond "OK"
        tls internal
      '';
    };
  };

}


