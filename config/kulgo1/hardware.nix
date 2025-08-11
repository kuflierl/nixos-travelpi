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
      # enable usb wifi dongle
      rtl88x2bu
    ];
  };

  hardware = {
    raspberry-pi."4" = {
      xhci.enable = true;
      # Enable GPU acceleration
      fkms-3d.enable = true;
    };
  };

  nixpkgs.hostPlatform = "aarch64-linux";
}
