{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "sr_mod"
  ];

  boot.initrd.kernelModules = [
  ];

  boot.kernelModules = [
  ];

  boot.extraModulePackages = [
  ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ {
    device = "/dev/disk/by-label/swap";
  }];

  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}