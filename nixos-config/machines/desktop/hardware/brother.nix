{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ../brother.nix
  ];

  nix.maxJobs = 4;
  nix.buildCores = 4;

  services.xserver.useGlamor = true;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "sr_mod" "rtsx_usb_sdmmc" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.blacklistedKernelModules = [
    "radeon" "amdgpu" # With Radeon enabled, resuming from `systemctl suspend` won’t work. Why?
    "i2c_designware_platform" "i2c_designware_core" # These block systemd-udev-settle.service at boot.
  ];
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=dell-m6-amic
  '';

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices.crypt = {
    device = "/dev/disk/by-uuid/7595fd97-90d1-42a2-822c-8785d5a4663b";
    # allowDiscards = true; # if SSD — has security implications!
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/07846ad2-f6a5-4398-8f2e-c7b2ac5d1c74";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/5482-A477";
    fsType = "vfat";
  };

  fileSystems."/mnt/Windows" = {
    device = "/dev/disk/by-uuid/2054F4BE54F497AC";
    fsType = "ntfs";
    options = [ "fmask=0111" "dmask=0000" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-uuid/67e88542-8ca6-4376-9547-16299cb08cb0"; }
  ];
}
