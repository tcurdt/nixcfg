{ buildGoModule, fetchFromGitHub, ... }:
# package that builds go binary
# nix build .#oci-resolve
buildGoModule rec {
  pname = "oci-resolve";
  version = "0.0.12";
  src = fetchFromGitHub {
    owner = "tcurdt";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WrRzrq3SmBQfdb71cErr9wg3qHq7UQOjwfK0KL8ZNZI=";
  };
  vendorHash = "sha256-jaAgWbyiIzSn1mDJKoFn2bbwbu/0D646hdhfDlmP97k=";
}
