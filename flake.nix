{
  description = "my servers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    #sshhook.url = "github:tcurdt/myfoo";
    # sshhook.url = "git+file:///Users/tcurdt/Desktop/nix/flake-sshhook/";

    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    # nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    # flake-utils.url = "github:numtide/flake-utils";
    # nixos-hardware.url = "github:nixos/nixos-hardware";
    # agenix.url = "github:ryantm/agenix";
    # cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";
    # home-manager.url = "github:nix-community/home-manager";

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
    # , sshhook
    , ...
    } @ inputs:

    {
      nixosConfigurations.utm-arm = import ./machines/foo.nix inputs;
    };


    # caddy
    #   www.paleocoran.de -> port
    #   www.cc.de -> port

    # https://github.com/marxmichael/paleocoran
    # path = docker-compose.yml
    # ref = live

    # {
    #   virtualisation.oci-containers.containers = {
    #     echo = {
    #     image = "ealen/echo-server";
    #     ports = [ "127.0.0.1:8080:80" ];
    #     # volumes = [
    #     #   "a:b"
    #     # ];
    #     # environment = {
    #     # };
    #     # extraOptions = [ "--pod=live-pc" ];
    #     };
    #   };
    # }


    # https://github.com/marxmichael/paleocoran/blob/live/docker-compose.yml
    # https://github.com/marxmichael/cc

    # let
    #   mkHost = import ./lib/mkHost.nix inputs;
    # in {
    #   nixosConfigurations.utm-arm = mkHost {
    #     hardware = "utm";
    #     hostPlatform = "aarch64-linux";
    #     hostName = "nixos";
    #   };
    # };
}
