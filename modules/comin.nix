{
  # pkgs,
  ...
}:
{
  services.comin = {
    enable = true;
    # environment = {
    #   GIT_SSH_COMMAND = "${pkgs.openssh}/bin/ssh -i <path to key>";
    # };
    remotes = [
      {
        name = "origin";
        url = "https://github.com/tcurdt/nixcfg.git";
        branches.testing.name = "main";
        # branches.main.name = "main";
        # flakeSubdirectory = ".";
        # auth.access_token_path = cfg.sops.secrets."gitlab/access_token".path;
        poller.period = 300; # 5 minutes
      }
    ];
    # machineId = "22823ba6c96947e78b006c51a56fd89c";
  };

}
