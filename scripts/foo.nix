{ pkgs, ... }:
pkgs.writeScriptBin "foo" ''
  #!${pkgs.bash}/bin/bash
  echo "hello $1"
  whoami
''
