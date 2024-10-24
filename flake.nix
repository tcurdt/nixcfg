{
  description = "my machines";

  inputs = {

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-stable";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";

    # home-manager-unstable.url = "github:nix-community/home-manager/master";
    # home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    impermanence.url = "github:nix-community/impermanence";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs-stable";

    # nixos-generators.url = "github:nix-community/nixos-generators";
    # nixos-generators.inputs.nixpkgs.follows = "nixpkgs-stable";

    # agenix.url = "github:ryantm/agenix";
    # agenix.inputs.nixpkgs.follows = "nixpkgs-stable";
    # agenix.inputs.darwin.follows = "";

    # release-go.url = "github:tcurdt/release-go";
    # release-go.inputs.nixpkgs.follows = "nixpkgs-stable";
    # sshhook.url = "git+file:///Users/tcurdt/Desktop/nix/flake-sshhook/";

  };

  outputs =
    { self
    , nixpkgs-stable
    , home-manager
    , impermanence
    , darwin
    , deploy-rs
    , ...
    } @ inputs:

    {

      # https://www.youtube.com/watch?v=LE5JR4JcvMg
      darwinConfigurations = {
        shodan = darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./machines/shodan.nix ];
        };
      };

      nixosConfigurations = {

        app = nixpkgs-stable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
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


        rpi-zero = nixpkgs-stable.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./machines/rpi-zero.nix ];
        };

      };

      images = {
        rpi-zero = self.nixosConfigurations.rpi-zero.config.system.build.sdImage;
      };

      colmena = {
        meta = {
          nixpkgs = import nixpkgs-stable {
            system = "aarch64-darwin";
          };
          specialArgs = { inherit inputs; };
        };

        utm-arm = {
          deployment = {
            targetHost = "192.168.78.7";
            targetUser = "root";
          };
          imports = [ ./machines/utm-arm.nix ];
        };

        # utm-x86 = import self.nixosConfigurations.utm-x86 {
        #   nixpkgs.system = "aarch64-linux";
        #   boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
        #   deployment = {
        #     tags = [ "vm" ];
        #     keys = {
        #       foo = {
        #         text = "text";
        #         # keyFile = "";
        #         # keyCommand = [];
        #         # user = "caddy"
        #         # uploadAt = "post-activation";
        #       };
        #     };
        #     targetHost = "192.168.71.3";
        #     targetUser = "root";
        #     # healthChecks = {
        #     #   http = [
        #     #     {
        #     #       scheme = "http";
        #     #       port = 80;
        #     #       path = "/";
        #     #       description = "check for http ingres";
        #     #     }
        #     #   ];
        #     # };
        #   };
        # };

      };

      deploy.nodes = {

        # nix run github:serokell/deploy-rs -- #utm-arm
        utm-arm = {
          hostname = "192.168.78.7";
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.utm-arm;
          };
        };

        # app = {
        #   hostname = "5.189.130.53";
        #   remoteBuild = false;
        #   sshUser = "root";
        #   profiles.system = {
        #     user = "root";
        #     path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.app;
        #   };
        # };

      };

      # nix build .#packages.aarch64-linux.utm
      # packages.aarch64-linux.utm = self.nixosConfigurations.utm-arm.config.formats.iso;

      # nix build .#packages.x86_64-linux.utm
      # packages.x86_64-linux.utm = self.nixosConfigurations.utm-x86.config.formats.iso;

    };
}
