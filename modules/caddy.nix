{ config, pkgs, ... }:
{

  services.caddy = {
    enable = true;

    # curl localhost -i -H "Host: example.org"
    virtualHosts."example.org" = {
      extraConfig = ''
        reverse_proxy http://127.0.0.1:8080
        tls internal
      '';
      serverAlias = [ "old.example.org" ];
    };
  };

}


