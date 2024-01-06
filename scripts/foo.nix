{ pkgs }:
{
  pkgs.writeShellScriptsBin "foo" ''
    echo "foo"
  ''

}
