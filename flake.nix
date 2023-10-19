{
    description = "a very basic flake";

    # nixConfig = {
    #     experimental-features = [ "nix-command" "flakes" ];
    # };

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

        # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";

        # nixos-hardware.url = "github:nixos/nixos-hardware";
        # home-manager.url = "github:nix-community/home-manager";
        # agenix.url = "github:ryantm/agenix";

        # home-manager = {
        #     url = "github:nix-community/home-manager";
        #     inputs.nixpkgs.follows = "nixpkgs";
        # };

        # darwin = {
        #     url = "github:LnL7/nix-darwin";
        #     inputs.nixpkgs.follows = "nixpkgs";
        # };

        # zig = {
        #     url = "github:mitchellh/zig-overlay";
        # };
    };

    outputs =
        { self
        , nixpkgs
        # , home-manager
        # , darwin
        , ...
        } @ inputs: {
        # nixosModules = import ./modules { lib = nixpkgs.lib; };
        nixosConfigurations = {

            serverA = nixpkgs.lib.nixosSystem {
                # specialArgs = { inherit inputs; };
                system = "x86_64-linux";
                modules = [

                    ./configuration.nix
                    # home-manager.nixosModules.home-manager
                    # agenix.nixosModules.age

                    # {
                    #   environment.etc.flake.source = self;
                    #   nix.registry.nixpkgs.flake = nixpkgs;
                    # }

                    # home-manager.nixosModule
                    # {
                    #   home-manager = {
                    #       useGlobalPkgs = true;
                    #   };
                    # }

                ];
            };

        };
    };
}
