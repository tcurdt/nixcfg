{
  inputs = {

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs-stable";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-stable";

    impermanence.url = "github:nix-community/impermanence";

    comin.url = "github:nlewo/comin";
    comin.inputs.nixpkgs.follows = "nixpkgs-stable";

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
    {
      # self,
      nixpkgs-stable,
      # home-manager,
      # impermanence,
      darwin,
      comin,
      # deploy-rs,
      ...
    }@inputs:
    let
      systems = [
        # "x86_64-darwin"
        "aarch64-darwin"
        "x86_64-linux"
        # "i686-linux"
        # "aarch64-linux"
      ];
      forAllSystems = nixpkgs-stable.lib.genAttrs systems;
    in
    {

      darwinConfigurations = {
        shodan = darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./machines/shodan.nix ];
        };
      };

      packages = forAllSystems (system: import ./packages nixpkgs-stable.legacyPackages.${system});
      # formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra)

      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {

        utm-arm = nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./machines/utm-arm.nix ];
        };

        utm-x86 = nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [ ./machines/utm-x86.nix ];
        };

        kube-michael = nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./machines/kube-michael.nix
            comin.nixosModules.comin
            (import ./modules/comin.nix)
          ];
        };

        app = nixpkgs-stable.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./machines/app.nix
            comin.nixosModules.comin
            (import ./modules/comin.nix)
          ];
        };

        # home-goe = nixpkgs-stable.lib.nixosSystem {
        #   specialArgs = {
        #     inherit inputs;
        #   };
        #   modules = [
        #     ./machines/home-goe.nix
        #     comin.nixosModules.comin
        #     (import ./modules/comin.nix)
        #   ];
        # };

        # home-ber = nixpkgs-stable.lib.nixosSystem {
        #   specialArgs = {
        #     inherit inputs;
        #   };
        #   modules = [
        #     ./machines/home-ber.nix
        #     comin.nixosModules.comin
        #     (import ./modules/comin.nix)
        #   ];
        # };

        # rpi-zero = nixpkgs-stable.lib.nixosSystem {
        #   specialArgs = { inherit inputs; };
        #   modules = [ ./machines/rpi-zero.nix ];
        # };

      };

      # deploy.nodes = {
      #   # nix run github:serokell/deploy-rs -- #utm-arm
      #   utm-arm = {
      #     hostname = "192.168.78.7";
      #     sshUser = "root";
      #     profiles.system = {
      #       user = "root";
      #       path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.utm-arm;
      #     };
      #   };
      #   # app = {
      #   #   hostname = "5.189.130.53";
      #   #   remoteBuild = false;
      #   #   sshUser = "root";
      #   #   profiles.system = {
      #   #     user = "root";
      #   #     path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.app;
      #   #   };
      #   # };
      # };

      # images = {
      #   rpi-zero = self.nixosConfigurations.rpi-zero.config.system.build.sdImage;
      # };

      # nix build .#packages.aarch64-linux.utm
      # packages.aarch64-linux.utm = self.nixosConfigurations.utm-arm.config.formats.iso;

      # nix build .#packages.x86_64-linux.utm
      # packages.x86_64-linux.utm = self.nixosConfigurations.utm-x86.config.formats.iso;

    };
}
