{ pkgs, ... }:
{
  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "https://github.com/tcurdt/nixcfg.git";
        branches.testing.name = "main";
        # auth.access_token_path = cfg.sops.secrets."gitlab/access_token".path;
        # poller.period = 5;
      }
    ];
    # machineId = "22823ba6c96947e78b006c51a56fd89c";
  };

}
