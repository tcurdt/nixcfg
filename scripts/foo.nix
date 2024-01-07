{ pkgs }:

let

  foo = pkgs.writeScriptBin "foo" ''
    #!${pkgs.bash}/bin/bash
    echo "hello $1"
    whoami
  '';

in {

  environment.systemPackages = [ foo ];

}