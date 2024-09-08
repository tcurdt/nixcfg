{ pkgs, ... }:
{
  services.ntfy-sh = {
    enable = true;

    settings = {
      base-url = "https://ntfy.vafer.org";
      upstream-base-url = "https://ntfy.sh";
      # upstream-access-token:
      listen-http = "127.0.0.1:8080";
      auth-default-access = "deny-all";
      behind-proxy = true;
      enable-login = false;
      web-root = "disable";
    };
  };
}
