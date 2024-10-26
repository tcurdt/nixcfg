{ pkgs, ... }:

let

  bar = pkgs.writeScriptBin "bar" ''
    #!${pkgs.bash}/bin/bash
    echo "hello $1"
    whoami
  '';

in
{

  environment.systemPackages = [ bar ];
}
