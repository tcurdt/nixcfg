{
  inputs = {

    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    # darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    # home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # temporary: k3s 1.33 for the 26.05 transition (not cached in 26.05, EOL)
    nixpkgs-2505.url = "github:nixos/nixpkgs/nixos-25.05";

    impermanence.url = "github:nix-community/impermanence";

    # comin.url = "github:nlewo/comin/v0.11.0";
    # comin.url = "github:nlewo/comin";
    # comin.inputs.nixpkgs.follows = "nixpkgs";

    # deploy-rs.url = "github:serokell/deploy-rs";
    # deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    # nixos-generators.url = "github:nix-community/nixos-generators";
    # nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # agenix.url = "github:ryantm/agenix";
    # agenix.inputs.nixpkgs.follows = "nixpkgs";
    # agenix.inputs.darwin.follows = "";

    # release-go.url = "github:tcurdt/release-go";
    # release-go.inputs.nixpkgs.follows = "nixpkgs";
    # sshhook.url = "git+file:///Users/tcurdt/Desktop/nix/flake-sshhook/";

  };

  outputs =
    {
      # self,
      nixpkgs,
      # home-manager,
      # impermanence,
      darwin,
      # comin,
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
      forAllSystems = nixpkgs.lib.genAttrs systems;
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

      packages = forAllSystems (system: import ./packages nixpkgs.legacyPackages.${system});
      # formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra)

      overlays = import ./overlays { inherit inputs; };

      nixosConfigurations = {

        #         utm-arm = nixpkgs.lib.nixosSystem {
        #           specialArgs = {
        #             inherit inputs;
        #           };
        #           modules = [ ./machines/utm-arm.nix ];
        #         };
        #
        #         utm-x86 = nixpkgs.lib.nixosSystem {
        #           specialArgs = {
        #             inherit inputs;
        #           };
        #           modules = [ ./machines/utm-x86.nix ];
        #         };

        # utm-x86-desktop = nixpkgs.lib.nixosSystem {
        #   specialArgs = {
        #     inherit inputs;
        #   };
        #   modules = [ ./machines/utm-x86-desktop.nix ];
        # };

        kube-michael = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./machines/kube-michael.nix
            # comin.nixosModules.comin
            # (import ./modules/comin.nix)
          ];
        };

        # app = nixpkgs.lib.nixosSystem {
        #   specialArgs = {
        #     inherit inputs;
        #   };
        #   modules = [
        #     ./machines/app.nix
        #     comin.nixosModules.comin
        #     (import ./modules/comin.nix)
        #   ];
        # };

        # home-goe = nixpkgs.lib.nixosSystem {
        #   specialArgs = {
        #     inherit inputs;
        #   };
        #   modules = [
        #     ./machines/home-goe.nix
        #     comin.nixosModules.comin
        #     (import ./modules/comin.nix)
        #   ];
        # };

        # home-ber = nixpkgs.lib.nixosSystem {
        #   specialArgs = {
        #     inherit inputs;
        #   };
        #   modules = [
        #     ./machines/home-ber.nix
        #     comin.nixosModules.comin
        #     (import ./modules/comin.nix)
        #   ];
        # };

        # rpi-zero = nixpkgs.lib.nixosSystem {
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
