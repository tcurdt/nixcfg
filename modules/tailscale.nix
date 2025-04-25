{
  # pkgs,
  ...
}:
{
  services.tailscale = {
    enable = true;

    openFirewall = false;
    authKeyFile = "/run/secrets/tailscale_key";
  };

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
}
