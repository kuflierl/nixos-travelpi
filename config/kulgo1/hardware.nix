{ config, ... }:
{
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  boot = {
    initrd.availableKernelModules = [ ];
    initrd.kernelModules = [ ];
    kernelModules = [ ];
    extraModulePackages = with config.boot.kernelPackages; [
      # enable usb wifi dongle (disabled due to newer kernels including this)
      # rtl88x2bu
    ];
  };

  hardware = {
    raspberry-pi."4" = {
      xhci.enable = true;

      apply-overlays-dtmerge.enable = true;
    };
    deviceTree = {
      enable = true;
      filter = "*rpi-4-*.dtb";
    };
  };

  # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  nixpkgs.hostPlatform = "aarch64-linux";
}
