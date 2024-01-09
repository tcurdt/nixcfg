
{ config, pkgs, inputs, ... }:
let

  xxx = pkgs.writeScriptBin "xxx" ''
      #!${pkgs.bash}/bin/bash
      echo "hello $1"
      whoami
    '';


in {

  imports = [ ../scripts/bar.nix ];

  environment.systemPackages = with pkgs; [
    (import ../scripts/foo.nix { inherit pkgs; })
    xxx
    curl
  ];

  systemd.services.stage1 = {
    enable = true;

    description = "stage 1";

    script = "${pkgs.writeScript "stage1" ''
      #!${pkgs.bash}/bin/bash
      echo "stage1 start"
      sleep 5
      whoami
      echo "stage1 stop"
      exit 0
      ''}";

    serviceConfig.Type = "oneshot";
    startAt = "minutely";

    onSuccess = [ "stage2.service" ];
  };

  systemd.services.stage2 = {
    enable = true;

    description = "stage 2";

    script = "${pkgs.writeScript "stage2" ''
      #!${pkgs.bash}/bin/bash
      echo "stage2 start"
      sleep 1
      whoami
      echo "stage2 stop"
      ''}";

    serviceConfig.Type = "oneshot";
    #after = [ "stage1.service" ];
    #wantedBy = [ "stage1.service" ];
  };

  # systemd.tmpfiles.rules = [
  #   "d /var/www"
  #   "d /var/www/example.org 0750 example example"
  # ];

}
