_: {
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
    # Kernel driver tuning to prevent dynamic bus autosuspend and link drops for WI-FI
    extraModprobeConfig = ''
      options brcmfmac feature_disable=0x82000
      options rtw88_core disable_lps_deep=y
      options rtw88_usb disable_autosuspend=y
    '';
    loader = {
      # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
      grub.enable = false;
      # Enables the generation of /boot/extlinux/extlinux.conf
      generic-extlinux-compatible.enable = true;
    };
  };

  hardware = {
    # Ensure regulatory database and redistributable firmware are accessible for WI-FI
    wirelessRegulatoryDatabase = true;
    enableRedistributableFirmware = true;
    # enable mode switching for multi certain USB WLAN and WWAN adapters
    usb-modeswitch.enable = true;
  };

  nixpkgs.hostPlatform = "aarch64-linux";
}
