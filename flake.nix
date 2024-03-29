{
  description = "my machines";

  inputs = {

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager-stable.url = "github:nix-community/home-manager/release-23.11";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    # agenix.url = "github:ryantm/agenix";
    # agenix.inputs.nixpkgs.follows = "nixpkgs";
    # agenix.inputs.darwin.follows = "";

    impermanence.url = "github:nix-community/impermanence";

    release-go.url = "github:tcurdt/release-go";
    release-go.inputs.nixpkgs.follows = "nixpkgs-stable";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs-stable";

    # cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";
    # darwin.url = "github:LnL7/nix-darwin";
    # darwin.inputs.nixpkgs.follows = "nixpkgs";
    # nixos-hardware.url = "github:nixos/nixos-hardware";
    # sshhook.url = "git+file:///Users/tcurdt/Desktop/nix/flake-sshhook/";
    # flake-utils.url = "github:numtide/flake-utils";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs-stable";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs-unstable";

  };

  outputs =
    { self
    , nixpkgs-unstable
    , nixpkgs-stable
    , home-manager-unstable
    , home-manager-stable
    , nixos-generators
    , impermanence
    , release-go
    , deploy-rs
    , disko
    # , agenix
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
          inherit nixos-generators;
          inherit release-go;
        };

        app = import ./machines/app.nix {
          hostName = "nixos";
          hostPlatform = "x86_64-linux";
          nixpkgs = nixpkgs-stable;
          home-manager = home-manager-stable;
          inherit impermanence;
          inherit release-go;
        };

        home-goe = import ./machines/home-goe.nix {
          hostName = "home-goe";
          hostPlatform = "x86_64-linux";
          nixpkgs = nixpkgs-stable;
          home-manager = home-manager-stable;
          inherit impermanence;
          inherit disko;
        };

        # home-ber
        # home-boat

        # cnc
        # laptop

      };

      # install-iso
      # iso
      # qcow
      # qcow-efi
      # amazon
      # azure
      # do
      # gce

      # nix build .#packages.x86_64-linux.utm-iso
      packages.x86_64-linux.utm-iso = self.nixosConfigurations.utm.config.formats.iso;

      # https://www.youtube.com/watch?v=LE5JR4JcvMg
      # darwinConfigurations = {
      #   shodan = import ./machines/shodan.nix inputs;
      # };

      # nix-shell -p colmena
      # colema = {
      #   # meta.specialArgs.inputs = inputs;
      #   # utm = import ./machines/utm.nix inputs;
      #   meta = {};
      #   utm = self.nixosConfigurations.utm // {
      #     deployment = {
      #       targetHost = "192.168.71.3";
      #       targetUser = "root";
      #       healthChecks = {
      #         http = [
      #           {
      #             scheme = "http";
      #             port = 80;
      #             path = "/";
      #             description = "check for http ingres";
      #           }
      #         ];
      #       };
      #     };
      #   };
      # };

      # nix run github:serokell/deploy-rs -- #utm
      deploy.nodes.utm = {
        hostname = "192.168.71.3";
        remoteBuild = true;
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.utm;
        };
      };

    };
}
