{
  # pkgs,
  ...
}:
{

  # smtp

  programs.msmtp = {
    enable = true;
    setSendmail = false;
    accounts = {
      default = {
        auth = true;
        tls = true;
        # tls_starttls = false; # if sendmail hangs
        from = "tcurdt@vafer.org";
        host = "email-smtp.eu-central-1.amazonaws.com";
        user = "AKIA3V6SV2TSVUAMXT4D";
        passwordeval = "cat /secrets/msmtp.key";
      };
    };
  };

}
