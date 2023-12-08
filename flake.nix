{
  description = "my servers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # sshhook.url = "github:tcurdt/myfoo";
    # sshhook.url = "git+file:///Users/tcurdt/Desktop/nix/flake-sshhook/";

    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    # flake-utils.url = "github:numtide/flake-utils";
    # nixos-hardware.url = "github:nixos/nixos-hardware";
    # agenix.url = "github:ryantm/agenix";
    # cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";
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
  };

  outputs =
    { self
    , nixpkgs
    # , sshhook
    , ...
    } @ inputs:

    {
      nixosConfigurations.utm = import ./machines/utm.nix inputs;
      nixosConfigurations.hetzner = import ./machines/hetzner.nix inputs;
    };

    # let
    #   mkHost = import ./lib/mkHost.nix inputs;
    # in {
    #   nixosConfigurations.utm = mkHost {
    #     hardware = "utm";
    #     hostPlatform = "aarch64-linux";
    #     hostName = "nixos";
    #   };
    # };
}
