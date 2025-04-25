{
  # pkgs,
  ...
}:
{
  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/tcurdt/nixcfg.git";
        branches.testing.name = "main";
        # auth.access_token_path = cfg.sops.secrets."gitlab/access_token".path;
        # poller.period = 60; # 1 minute
        poller.period = 300; # 5 minutes
      }
    ];
    # machineId = "22823ba6c96947e78b006c51a56fd89c";
  };

}
