{ buildGoModule, fetchFromGitHub, ... }:
# package that builds go binary
buildGoModule rec {
  pname = "oci-resolve";
  version = "0.0.12";
  src = fetchFromGitHub {
    owner = "tcurdt";
    repo = pname;
    rev = "v${version}";
    sha256 = "";
  };
  vendorHash = "";
}
