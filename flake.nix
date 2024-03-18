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
    # , agenix
    # , darwin
    , ...
    } @ inputs:

    {

      nixosConfigurations = {

        # utm
        # app
        # cnc
        # home-goe
        # home-ber
        # home-boat
        # laptop

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
          inherit nixos-generators;
          inherit release-go;
        };

        home-goe = import ./machines/home-goe.nix {
          hostName = "home-goe";
          hostPlatform = "x86_64-linux";
          nixpkgs = nixpkgs-stable;
          home-manager = home-manager-stable;
          inherit impermanence;
          inherit nixos-generators;
        };

      };

      packages.x86_64-linux.utm = self.nixosConfigurations.utm.config.formats.iso;

      # install-iso
      # iso
      # qcow
      # qcow-efi
      # amazon
      # azure
      # do
      # gce

      # packages.x86_64-linux = {

      #   iso = nixos-generators.nixosGenerate {
      #     system = "x86_64-linux";
      #     # modules = [
      #     # ];
      #     format = "iso";
      #   };

      #   vmware = nixos-generators.nixosGenerate {
      #     system = "x86_64-linux";
      #     modules = [
      #       # ./configuration.nix
      #     ];
      #     format = "vmware";
      #     # optional arguments:
      #     # explicit nixpkgs and lib:
      #     # pkgs = nixpkgs.legacyPackages.x86_64-linux;
      #     # lib = nixpkgs.legacyPackages.x86_64-linux.lib;
      #     # additional arguments to pass to modules:
      #     # specialArgs = { myExtraArg = "foobar"; };
      #   };

      #   vbox = nixos-generators.nixosGenerate {
      #     system = "x86_64-linux";
      #     format = "virtualbox";
      #   };

      # };

      # https://www.youtube.com/watch?v=LE5JR4JcvMg
      # darwinConfigurations.shodan = import ./machines/shodan.nix inputs;

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
      # checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;

    };
}
