{
  description = "my machines";

  inputs = {

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-stable.url = "github:nix-community/home-manager/release-23.11";

    # home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";
    # home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # agenix.url = "github:ryantm/agenix";
    # agenix.inputs.nixpkgs.follows = "nixpkgs";
    # agenix.inputs.darwin.follows = "";

    impermanence.url = "github:nix-community/impermanence";
    # impermanence.inputs.nixpkgs.follows = "nixpkgs";

    release-go.url = "github:tcurdt/release-go";

    # cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";
    # darwin.url = "github:LnL7/nix-darwin";
    # darwin.inputs.nixpkgs.follows = "nixpkgs";
    # nixos-hardware.url = "github:nixos/nixos-hardware";
    # deploy-rs.url = "github:serokell/deploy-rs";
    # sshhook.url = "git+file:///Users/tcurdt/Desktop/nix/flake-sshhook/";
    # flake-utils.url = "github:numtide/flake-utils";

  };

  outputs =
    { self
    , nixpkgs-unstable
    , nixpkgs-stable
    , home-manager-unstable
    , home-manager-stable
    , home-manager
    , impermanence
    , release-go
    # , agenix
    # , deploy-rs
    # , darwin
    , ...
    } @ inputs:

    {

      nixosConfigurations = {

        utm = import ./machines/utm.nix {
          hostName = "nixos";
          hostPlatform = "aarch64-linux";
          nixpkgs = nixpkgs-unstable;
          home-manager = home-manager-unstable;
          inherit impermanence;
          inherit release-go;
        };

        hetzner = import ./machines/hetzner.nix {
          hostName = "nixos";
          hostPlatform = "x86_64-linux";
          nixpkgs = nixpkgs-stable;
          home-manager = home-manager-stable;
          inherit impermanence;
          inherit release-go;
        };

      };

      # utm
      # app
      # cnc
      # home-goe
      # home-ber
      # home-boat
      # laptop

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
