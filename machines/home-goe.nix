# { nixpkgs, hostName, hostPlatform, impermanence, disko, ... } @ inputs: let

#   pkgs = nixpkgs.legacyPackages.${hostPlatform};

# in nixpkgs.lib.nixosSystem {

#   specialArgs = { inherit inputs; };

#   modules = [

#     # inputs.nixos-generators.nixosModules.all-formats

#     {
#       nixpkgs.hostPlatform = hostPlatform;
#       networking.hostName = hostName;
#       networking.domain = "home";
#       system.stateVersion = "23.11";
#       # system.stateVersion = "24.05";
#     }

#     ../hardware/home.nix
#     disko.nixosModules.disko
#     {
#       disko.devices = {
#         disk = {
#           vdb = {
#             device = "/dev/nvme0n1";
#             type = "disk";
#             content = {
#               type = "gpt";
#               partitions = {
#                 boot = {
#                   size = "1M";
#                   type = "EF02"; # for grub MBR
#                 };
#                 root = {
#                   size = "100%";
#                   content = {
#                     type = "filesystem";
#                     format = "ext4";
#                     mountpoint = "/";
#                     postMountHook = "mkdir -p /mnt/nix/persist";
#                   };
#                 };
#               };
#             };
#           };
#         };
#       };
#     }

#     ../users/root.nix
#     ../users/tcurdt.nix

#     {
#       users.users.root.password = "secret";
#     }

#     ../modules/server.nix
#     ../modules/users.nix

#     # ../modules/telegraf.nix
#     # ../modules/db-influx.nix
#     # ../modules/homeassistant.nix

#     # ../modules/zerotierone.nix
#     # ../modules/tailscale.nix

#     # inputs.release-go.nixosModules.default

#     {
#       networking.firewall.allowedTCPPorts = [ 80 443 ];
#       services.caddy = {
#         enable = true;

#         # virtualHosts."homeassistant.home" = {
#         #   extraConfig = ''
#         #     reverse_proxy 127.0.0.1:2020
#         #     tls internal
#         #   '';
#         # };

#       };
#     }

#   ];
# }
