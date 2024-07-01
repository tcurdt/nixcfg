{
  description = "my machines";

  inputs = {

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";

    home-manager-unstable.url = "github:nix-community/home-manager/master";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    home-manager-stable.url = "github:nix-community/home-manager/release-24.05";
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
          hostName = "utm";
          hostPlatform = "aarch64-linux";
          nixpkgs = nixpkgs-stable;
          home-manager = home-manager-stable;
          inherit impermanence;
          # inherit nixos-generators;
          # inherit release-go;
        };

        # utm = import ./machines/utm.nix {
        #   hostName = "utm";
        #   hostPlatform = "aarch64-linux";
        #   nixpkgs = nixpkgs-unstable;
        #   home-manager = home-manager-unstable;
        #   inherit impermanence;
        #   inherit nixos-generators;
        #   # inherit release-go;
        # };

        app = import ./machines/app.nix {
          hostName = "app";
          hostPlatform = "x86_64-linux";
          nixpkgs = nixpkgs-stable;
          home-manager = home-manager-stable;
          inherit impermanence;
          # inherit release-go;
        };

        kube-edkimo = import ./machines/kube-edkimo.nix {
          hostName = "kube-edkimo";
          hostPlatform = "x86_64-linux";
          nixpkgs = nixpkgs-stable;
          home-manager = home-manager-stable;
          inherit impermanence;
        };

        kube-michael = import ./machines/kube-michael.nix {
          hostName = "kube-michael";
          hostPlatform = "x86_64-linux";
          nixpkgs = nixpkgs-stable;
          home-manager = home-manager-stable;
          inherit impermanence;
        };

        # home-goe = import ./machines/home-goe.nix {
        #   hostName = "home-goe";
        #   hostPlatform = "x86_64-linux";
        #   nixpkgs = nixpkgs-stable;
        #   home-manager = home-manager-stable;
        #   inherit impermanence;
        #   inherit disko;
        # };

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


      # nix build .#packages.aarch64-linux.utm-iso
      # packages.aarch64-linux.utm-iso = self.nixosConfigurations.utm.config.formats.iso;

      # $ nix build .#packages.aarch64-linux.utm-iso
      # error: a 'aarch64-linux' with features {} is required to build '/nix/store/srv0wy1ljxyiibv1alvn1pp9rgjs67xs-gomod2nix-symlink.drv', but I am a 'aarch64-darwin' with features {apple-virt, benchmark, big-parallel, nixos-test}
      # 1. build the aarch64-linux image on aarch64-darwin
      # 2. build a utm image instead of an iso

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
      # deploy.nodes.utm = {
      #   hostname = "192.168.71.3";
      #   remoteBuild = true;
      #   profiles.system = {
      #     user = "root";
      #     path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.utm;
      #   };
      # };

    };
}
