{ config, pkgs, ... }:
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/media/General-Media" = {
      device = "/dev/disk/by-label/General-Media";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  boot = {
    initrd.availableKernelModules = [ ];
    initrd.kernelModules = [ ];
    kernelModules = [ "88x2bu" ];
    extraModulePackages = with config.boot.kernelPackages; [
      # enable usb wifi dongle (disabled due to newer kernels including this)
      rtl88x2bu
    ];
    blacklistedKernelModules = [
      "rtw88_8822bu"
      "rtw88_usb"
    ];
  };

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  # enable mode switching for multi certain USB WLAN and WWAN adapters
  hardware.usb-modeswitch.enable = true;

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  nixpkgs.hostPlatform = "aarch64-linux";
}
