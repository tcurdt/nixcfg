{
    description = "a very basic flake";

    # nixConfig = {
    #     experimental-features = [ "nix-command" "flakes" ];
    # };
    # nix.extraOptions = ''
    #     experimental-features = nix-command flakes
    # '';
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

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

            utm-arm = nixpkgs.lib.nixosSystem {
                # specialArgs = { inherit inputs; };

                # system = "x86_64-linux";
                system = "aarch64-linux";

                modules = [

                    ./hosts/utm-arm/hardware-configuration.nix
                    ./modules/server.nix
                    ./modules/users.nix

                    {
                      networking.hostName = "nixos";
                      networking.domain = "utm";
                      system.stateVersion = "23.05";
                    }

                    # {
                    #   environment.etc.flake.source = self;
                    #   nix.registry.nixpkgs.flake = nixpkgs;
                    # }

                    # agenix.nixosModules.age

                    # home-manager.nixosModules.home-manager
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
