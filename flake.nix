{
  description = "my machines";

  inputs = {

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # darwin.url = "github:LnL7/nix-darwin";
    # darwin.inputs.nixpkgs.follows = "nixpkgs-stable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";

    # home-manager-unstable.url = "github:nix-community/home-manager/master";
    # home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    impermanence.url = "github:nix-community/impermanence";

    # agenix.url = "github:ryantm/agenix";
    # agenix.inputs.nixpkgs.follows = "nixpkgs-stable";
    # agenix.inputs.darwin.follows = "";

    # release-go.url = "github:tcurdt/release-go";
    # release-go.inputs.nixpkgs.follows = "nixpkgs-stable";
    # sshhook.url = "git+file:///Users/tcurdt/Desktop/nix/flake-sshhook/";

    # deploy-rs.url = "github:serokell/deploy-rs";
    # deploy-rs.inputs.nixpkgs.follows = "nixpkgs-stable";

    # nixos-generators.url = "github:nix-community/nixos-generators";
    # nixos-generators.inputs.nixpkgs.follows = "nixpkgs-stable";

  };

  outputs =
    { self
    , nixpkgs-stable
    , home-manager
    , impermanence
    , ...
    } @ inputs:

    {

      # https://www.youtube.com/watch?v=LE5JR4JcvMg
      # darwinConfigurations = {
      #   shodan = import ./machines/shodan.nix inputs;
      # };

      nixosConfigurations = {

        app = nixpkgs-stable.lib.nixosSystem {
          # system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            # inputs = inputs // {
            #   home-manager = home-manager-stable;
            # };
          };
          modules = [ ./machines/app.nix ];
        };


        utm-arm = nixpkgs-stable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./machines/utm-arm.nix ];
        };

        utm-x86 = nixpkgs-stable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./machines/utm-x86.nix ];
        };


        kube-edkimo = nixpkgs-stable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./machines/kube-edkimo.nix ];
        };

        kube-michael = nixpkgs-stable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./machines/kube-michael.nix ];
        };


        home-goe = nixpkgs-stable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./machines/home-goe.nix ];
        };

        home-ber = nixpkgs-stable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./machines/home-ber.nix ];
        };

      };

      # install-iso
      # iso
      # qcow
      # qcow-efi
      # amazon
      # azure
      # do
      # gce


      # $ nix build .#packages.aarch64-linux.utm-iso
      # packages.aarch64-linux.utm-iso = self.nixosConfigurations.utm.config.formats.iso;

      # $ nix build .#packages.aarch64-linux.utm-iso
      # error: a 'aarch64-linux' with features {} is required to build '/nix/store/srv0wy1ljxyiibv1alvn1pp9rgjs67xs-gomod2nix-symlink.drv', but I am a 'aarch64-darwin' with features {apple-virt, benchmark, big-parallel, nixos-test}
      # 1. build the aarch64-linux image on aarch64-darwin
      # 2. build a utm image instead of an iso

      # $ nix-shell -p colmena
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

      # $ nix run github:serokell/deploy-rs -- #utm
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
