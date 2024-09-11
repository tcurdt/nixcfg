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

    # deploy-rs.url = "github:serokell/deploy-rs";
    # deploy-rs.inputs.nixpkgs.follows = "nixpkgs-stable";

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
    # , deploy-rs
    , ...
    } @ inputs:

    {

      # https://www.youtube.com/watch?v=LE5JR4JcvMg
      darwinConfigurations = {
        shodan = darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./machines/shodan.nix ];
          system = "aarch64-darwin";
          # boot.binfmt.emulatedSystems = [ "aarch64-linux" "x86_64-linux" ];
        };
      };

      nixosConfigurations = {

        app = nixpkgs-stable.lib.nixosSystem {
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

      # boot.binfmt.emulatedSystems = [];
      # deploy.nodes = {

      #   # nix run github:serokell/deploy-rs -- #app
      #   app = {
      #     hostname = "5.189.130.53";
      #     remoteBuild = false;
      #     # sshUser = "x";
      #     profiles.system = {
      #       user = "root";
      #       path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.app;
      #     };
      #   };

      #   # nix run github:serokell/deploy-rs -- #utm-arm
      #   utm-arm = {
      #     hostname = "192.168.71.3";
      #     remoteBuild = false;
      #     # sshUser = "x";
      #     profiles.system = {
      #       user = "root";
      #       path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.utm-arm;
      #     };
      #   };

      # };

      # nix-shell -p colmena
      # colmena apply --on @vm
      colema = {
        # meta = {};
        # meta.specialArgs.inputs = inputs;
        # meta.specialArgs = { inherit inputs; };
        # meta = {
        #   nixpkgs = import nixpkgs {
        #     system = "x86_64-linux";
        #     overlays = [];
        #   };
        # };

        utm-arm = self.nixosConfigurations.utm-arm // {
          deployment = {
            tags = [ "vm" ];
            keys = {
              foo = {
                text = "";
                # keyFile = "";
                # keyCommand = [];
                # user = "caddy"
                # uploadAt = "post-activation";
              };
            };
            targetHost = "192.168.71.3";
            targetUser = "root";
            # healthChecks = {
            #   http = [
            #     {
            #       scheme = "http";
            #       port = 80;
            #       path = "/";
            #       description = "check for http ingres";
            #     }
            #   ];
            # };
          };
        };

        utm-x86 = self.nixosConfigurations.utm-x86 // {
          deployment = {
            tags = [ "vm" ];
            keys = {
              foo = {
                text = "";
                # keyFile = "";
                # keyCommand = [];
                # user = "caddy"
                # uploadAt = "post-activation";
              };
            };
            targetHost = "192.168.71.3";
            targetUser = "root";
            # healthChecks = {
            #   http = [
            #     {
            #       scheme = "http";
            #       port = 80;
            #       path = "/";
            #       description = "check for http ingres";
            #     }
            #   ];
            # };
          };
        };

      };

      # nix build .#packages.aarch64-linux.utm-iso
      # packages.aarch64-linux.utm-iso = self.nixosConfigurations.utm.config.formats.iso;

    };
}
