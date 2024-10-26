{
  config,
  pkgs,
  lib,
  ...
}:

let

  hookScript = pkgs.writeScriptBin "hook" ''
    #!${pkgs.bash}/bin/bash
    echo "hello $1"
    whoami
  '';

in
{

  users.users.webhook = {
    packages = [ hookScript ];
  };

  # systemd.services.webhook.serviceConfig.EnvironmentFile = config.age.secrets."foo".path;
  # systemd.services.webhook.serviceConfig.EnvironmentFile = /run/secrets/webhook

  services.webhook.enable = true;
  services.webhook.openFirewall = true;
  services.webhook.port = 19191;
  # services.webhook.hooksTemplated = {
  #   deploy = ''
  #     {
  #       "id": "deploy",
  #       "execute-command": "echo",
  #       "response-message": "{{ getenv "MESSAGE" }}"
  #     }
  #   '';
  # };
  services.webhook.hooks = {
    echo = {
      execute-command = "echo";
      response-message = "webhook is reachable!";
    };
    deploy = {
      execute-command = lib.getExe hookScript;
      include-command-output-in-response = true;
      # include-command-output-in-response-on-error = true;
      # command-working-directory = "/var/webhook";
      # pass-arguments-to-command = [
      #   {
      #     source = "payload";
      #     name = "head_commit.id";
      #   }
      #   {
      #     source = "payload";
      #     name = "pusher.name";
      #   }
      #   {
      #     source = "payload";
      #     name = "pusher.email";
      #   }
      # ];
      # trigger-rule = {
      #   and = [
      #     {
      #       match = {
      #         type = "payload-hmac-sha1";
      #         secret = "mysecret";
      #         parameter = {
      #           source = "header";
      #           name = "X-Hub-Signature";
      #         };
      #       };
      #     }
      #     {
      #       match = {
      #         type = "value";
      #         value = "refs/heads/master";
      #         parameter = {
      #           source = "payload";
      #           name = "ref";
      #         };
      #       };
      #     }
      #   ];
      # };

    };
  };

  security.sudo = {
    enable = true;
    extraRules = [
      {
        commands = [
          {
            command = lib.getExe hookScript;
            options = [ "NOPASSWD" ];
          }
          # {
          #   command = "/etc/profiles/per-user/hook/bin/hook";
          #   options = [ "NOPASSWD" ];
          # }
        ];
        users = [ "webhook" ];
      }
    ];
  };

}
