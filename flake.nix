{
  description = "my machines";

  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05"; # stable
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11"; # stable

    # nixos-hardware.url = "github:nixos/nixos-hardware";

    # deploy-rs.url = "github:serokell/deploy-rs";

    impermanence.url = "github:nix-community/impermanence";
    impermanence.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # darwin.url = "github:LnL7/nix-darwin";
    # darwin.inputs.nixpkgs.follows = "nixpkgs";

    # agenix.url = "github:ryantm/agenix";
    # agenix.inputs.nixpkgs.follows = "nixpkgs";
    # agenix.inputs.darwin.follows = "";

    # sshhook.url = "git+file:///Users/tcurdt/Desktop/nix/flake-sshhook/";

    # flake-utils.url = "github:numtide/flake-utils";
    # cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";
  };

  outputs =
    { self
    , nixpkgs
    , impermanence
    , home-manager
    # , deploy-rs
    # , darwin
    # , agenix
    , ...
    } @ inputs:

    {

      nixosConfigurations.utm = import ./machines/utm.nix inputs;
      nixosConfigurations.hetzner = import ./machines/hetzner.nix inputs;

      # https://www.youtube.com/watch?v=LE5JR4JcvMg
      # darwinConfigurations.shodan = import ./machines/shodan.nix inputs;

      # colema = {
      #   meta.specialArgs.inputs = inputs;
      #   utm = import ./machines/utm.nix inputs;
      # };

      # deploy.nodes.utm = {
      #   hostname = "127.0.0.1";
      #   remoteBuild = true;
      #   profiles.system = {
      #     user = "root";
      #     path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.utm;
      #   };
      # };
      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
    };

}
