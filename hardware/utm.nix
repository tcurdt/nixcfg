{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "nodev";
  };

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
  boot.initrd.kernelModules = [ "nvme" ];

  fileSystems."/boot" = { device = "/dev/disk/by-uuid/D155-033C"; fsType = "vfat"; };

  fileSystems."/" = { device = "/dev/vda2"; fsType = "ext4"; };

  swapDevices = [ { device = "/dev/vda3"; } ];
}
