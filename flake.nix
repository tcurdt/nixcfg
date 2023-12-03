{
  description = "my servers";

  #nixConfig = {
  #    experimental-features = [ "nix-command" "flakes" ];
  #};
  # nix.extraOptions = ''
  #     experimental-features = nix-command flakes
  # '';
  #nix.settings.experimental-features = [ "nix-command" "flakes" ];

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    # flake-utils.url = "github:numtide/flake-utils";

    # nixos-hardware.url = "github:nixos/nixos-hardware";
    # agenix.url = "github:ryantm/agenix";
    # home-manager.url = "github:nix-community/home-manager";
    # home-manager = {
    #     url = "github:nix-community/home-manager";
    #     inputs.nixpkgs.follows = "nixpkgs";
    # };
    # darwin = {
    #     url = "github:LnL7/nix-darwin";
    #     inputs.nixpkgs.follows = "nixpkgs";
    # };
    # zig = {
    #     url = "github:mitchellh/zig-overlay";
    # };
    # cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";
  };

  outputs =
    { self
    , nixpkgs
    # , home-manager
    # , darwin
    , ...
    } @ inputs:

    let
      mkHost = import ./lib/mkHost.nix { inherit nixpkgs; };
    in {

      nixosConfigurations.utm-arm = mkHost {
        hardware = "utm";
        hostPlatform = "aarch64-linux";
        hostName = "nixos";
      };

    };
}
