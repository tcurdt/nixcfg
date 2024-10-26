{ inputs, ... }:
{
  additions = final: _prev: import ../packages final.pkgs;

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    #     src = self.pkgs.fetchFromGitHub {
    #       owner = "illustris";
    #       repo = "st";
    #       rev = "fa363487355fe0b27d82e7247577802ac66e4b0f";
    #       hash = "sha256-KLh4yGSq7pf6F+mWZvH6slN+Qa1/LkjWbhFTxQ2vYng=";
    #     };
    # });
  };

  # nixpkgs-unstable will be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

}
