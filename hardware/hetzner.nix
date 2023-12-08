{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  # boot.growPartition = true;
  boot.loader.grub.device = "/dev/sda";

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" "vmw_pvscsi" ];
  boot.initrd.kernelModules = [ "nvme" ];

  fileSystems."/" = { device = "/dev/sda1"; fsType = "ext4"; };

  # services.cloud-init = {
  #   enabled = true;
  #   network.enable = true;
  # };

  # networking.useNetworkd = true;
  # networking.useDHCP = false;
  # networking.hostName = "";
}