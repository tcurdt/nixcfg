{ config, pkgs, lib, inputs, ... }:

	let

    hookScript = pkgs.writeScriptBin "hook" ''
      #!${pkgs.bash}/bin/bash
      echo "hello $1"
      whoami
    '';

  in {

    users.users.hook = {
      isNormalUser = true;
      packages = [ hookScript ];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA2CLOzyXcqk4uo6hCkkQAtozJCebA/Dh4ps6Vr2GVNTC7j7nF5HuT+penp/Y9yPAuTorxunmFn7BPwZggzopEgfmUQ4gf0CysTwPQMxt9yK3ZHpxgkGoJyR0n91OdPAbukqwWZHYxGGxvHNoap59kobUrIImIa97gKxW+IVKwL9iyWXyqonRpue1mf1N1ioDtPLS1yvzf4Jo7aDND+4I/34X6436VwZItUwzvhFcuNh/gQmvKpmVjD+ED2Q/yRtGq0EzsPfrDZg1ZKV5V1cT/3w7QtYFcZB9+AQxq88jVRcIlf3K45kpmbsWVfBFN6ND+NeZK1mlp/3TV8C6dNVqU2w== tcurdt@shodan.local"
      ];
    };

    services.webhook.enable = true;
    services.webhook.openFirewall = true;
    services.webhook.port = 19191;
    services.webhook.user = "hook";
    services.webhook.extraArgs = [];
    services.webhook.hooks = {
      echo = {
        execute-command = "echo";
        response-message = "webhook is reachable!";
      };
      redeploy-webhook = {
        execute-command = lib.getExe hookScript;
        # command-working-directory = "/var/webhook";
        pass-arguments-to-command = [
          {
            source = "payload";
            name = "head_commit.id";
          }
          {
            source = "payload";
            name = "pusher.name";
          }
          {
            source = "payload";
            name = "pusher.email";
          }
        ];
        trigger-rule = {
          and = [
            {
              match = {
                type = "payload-hmac-sha1";
                secret = "mysecret";
                parameter = {
                  source = "header";
                  name = "X-Hub-Signature";
                };
              };
            }
            # {
            #   match = {
            #     type = "value";
            #     value = "refs/heads/master";
            #     parameter = {
            #       source = "payload";
            #       name = "ref";
            #     };
            #   };
            # }
          ];
        };

      };
    };

    security.sudo = {
      enable = true;
      extraRules = [{
        commands = [
          {
            command = lib.getExe hookScript;
            options = [ "NOPASSWD" ];
          }
          {
            command = "/etc/profiles/per-user/hook/bin/hook";
            options = [ "NOPASSWD" ];
          }
        ];
        users = [ "hook" ];
      }];
    };

}
