{ pkgs }:

pkgs.writeShellScriptsBin "foo" ''
  ${pkgs.bar}/bin/bar
''