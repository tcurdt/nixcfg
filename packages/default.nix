{ pkgs, ... }:
with pkgs;
{
  oci-resolve = callPackage ./oci-resolve { };
  gh-get = callPackage ./gh-get { };
}
