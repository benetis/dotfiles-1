{ config, lib, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ../base-mine.nix
    ../modules/musnix.nix
    ../modules/android-dev.nix
  ];

  nix.maxJobs = 4;
  nix.buildCores = 4;

  time.timeZone = "Europe/Warsaw";

  hardware.sane.extraConfig.pixma = "bjnp://10.0.1.5";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ehci_pci" "ahci" "usb_storage" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/disk/by-id/ata-ST1000LM024_HN-M101MBB_S2WZJA0D350922";
  };

  boot.initrd.luks.devices = [{
    name = "crypt";
    device = "/dev/disk/by-uuid/f671aaa7-2b5c-44e3-9c83-6997edb4bcc4";
    # allowDiscards = true; # if SSD
  }];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/99f04383-1326-4321-af74-995070736843";
    fsType = "ext4";
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-uuid/1726aad0-192d-4df3-b90f-997708979298";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/e8e6dc50-7814-473e-8d52-aebcd83afd87";
    fsType = "ext4";
  };

  fileSystems."/home" = {
    device = "/var/home";
    fsType = "none";
    options = [ "bind" ];
  };

  swapDevices = [ { device = "/var/swap"; } ];
}