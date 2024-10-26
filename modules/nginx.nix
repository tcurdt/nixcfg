{ pkgs, ... }:
{

  # services.nginx.enable = true;
  # services.nginx.virtualHosts."myhost.org" = {
  #   addSSL = true;
  #   enableACME = true;
  #   root = "/var/www/myhost.org";
  # };
  # security.acme = {
  #   acceptTerms = true;
  #   defaults.email = "foo@bar.com";
  #   "blog.example.com".email = "youremail@address.com";
  # };

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedTlsSettings = true;
    recommendedProxySettings = true;

    #sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

    appendHttpConfig = ''
      #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;
      #add_header 'Referrer-Policy' 'origin-when-cross-origin';
      #add_header X-Frame-Options DENY;
      #add_header X-Content-Type-Options nosniff;
      #proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';

    # virtualHosts."example.com" =  {
    #   enableACME = true;
    #   forceSSL = true;
    #   locations."/" = {
    #     proxyPass = "http://127.0.0.1:12345";
    #     proxyWebsockets = true;
    #     extraConfig =
    #       # required when the target is also TLS server with multiple hosts
    #       "proxy_ssl_server_name on;" +
    #       # required when the server wants to use HTTP Authentication
    #       "proxy_pass_header Authorization;"
    #       ;
    #   };
    # };

    # virtualHosts = let
    #   base = locations: {
    #     inherit locations;
    #     forceSSL = true;
    #     enableACME = true;
    #   };
    #   proxy = port: base {
    #     "/".proxyPass = "http://127.0.0.1:" + toString(port) + "/";
    #   };
    # in {
    #   "example.com" = proxy 3000 // { default = true; };
    # };

  };

}
