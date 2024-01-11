{ nixpkgs, impermanence, ... }@inputs: let

  hardware = "utm";
  hostPlatform = "aarch64-linux";
  hostName = "nixos";

  pkgs = nixpkgs.legacyPackages.${hostPlatform};

in nixpkgs.lib.nixosSystem {

  specialArgs = { inherit inputs; };

  modules = [
    # agenix.nixosModules.default
    ../hardware/${hardware}.nix
    ../modules/server.nix
    ../modules/users.nix
    # ../modules/docker.nix
    # ../modules/podman.nix
    # ../modules/k3s.nix
    # ../modules/ssh-hook.nix
    # ../modules/web-hook.nix
    # ../modules/backup.nix

    {
      nixpkgs.hostPlatform = hostPlatform;
      networking.hostName = hostName;
      networking.domain = "utm";
      system.stateVersion = "23.11";
    }

    ../users/root.nix
    ../users/tcurdt.nix

    {
      users.users.root.password = "secret";
    }

  ];
}
