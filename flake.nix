{
  description = "my machines";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    # nixos-hardware.url = "github:nixos/nixos-hardware";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    impermanence.url = "github:nix-community/impermanence";
    # impermanence.inputs.nixpkgs.follows = "nixpkgs";

    # darwin.url = "github:LnL7/nix-darwin";
    # darwin.inputs.nixpkgs.follows = "nixpkgs";

    # agenix.url = "github:ryantm/agenix";
    # agenix.inputs.nixpkgs.follows = "nixpkgs";
    # agenix.inputs.darwin.follows = "";

    # sshhook.url = "github:tcurdt/myfoo";
    # sshhook.url = "git+file:///Users/tcurdt/Desktop/nix/flake-sshhook/";

    # flake-utils.url = "github:numtide/flake-utils";
    # cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";
  };

  outputs =
    { self
    , nixpkgs
    , impermanence
    , home-manager
    # , darwin
    # , agenix
    , ...
    } @ inputs:

    {

      nixosConfigurations.utm = import ./machines/utm.nix inputs;
      nixosConfigurations.hetzner = import ./machines/hetzner.nix inputs;

      # https://www.youtube.com/watch?v=LE5JR4JcvMg
      # darwinConfigurations.shodan = import ./machines/shodan.nix inputs;
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

    # let
    #   mkHost = import ./lib/mkHost2.nix inputs;
    # in {
    #   nixosConfigurations.utm = mkHost {
    #     hardware = "utm";
    #     hostPlatform = "aarch64-linux";
    #     hostName = "nixos";
    #   };
    # };

}
