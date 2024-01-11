# let
#   mkHost = import ./lib/mkHost.nix inputs;
# in {
#   nixosConfigurations.utm = mkHost {
#     hardware = "utm";
#     hostPlatform = "aarch64-linux";
#     hostName = "nixos";
#   };
# };

# let
#   mkHost = import ./lib/mkHost2.nix inputs;
# in {
#   nixosConfigurations.utm = mkHost {
#     hardware = "utm";
#     hostPlatform = "aarch64-linux";
#     hostName = "nixos";
#   };
# };
