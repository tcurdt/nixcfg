{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  # imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.initrd.availableKernelModules = [
  #  "xhci_pci"
  #  "sr_mod"
  #];
  boot.initrd.includeDefaultModules = false;
  boot.initrd.kernelModules = [
    "ext4"
    "mmc_block"
  ];
  # boot.kernelModules = [ ];
  # boot.extraModulePackages = [ ];

  # disabledModules = [
  #   "${modulesPath}/profiles/all-hardware.nix"
  #   "${modulesPath}/profiles/base.nix"
  # ];

  nixpkgs.hostPlatform = lib.mkDefault "armv6l-linux";

  fileSystems."/" = {
    device = "/dev/disk/by-label/root";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  hardware.firmware = [ pkgs.raspberrypiWirelessFirmware ];
  networking.networkmanager.wifi.powersave = false;
  networking.useDHCP = lib.mkDefault true;
  networking = {
    wireless = {
      enable = true;
    };
  };
}
