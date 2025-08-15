{ lib, pkgs, ... }:
{
  imports = [
    ./users.nix
    ./services
    ./sops.nix
    ./hardware.nix
    ./networking.nix
    # ./wireless.nix
  ];

  networking.hostName = "kulgo1";

  time.timeZone = lib.mkDefault "Europe/Berlin";

  nix = {
    settings.allowed-users = [
      "@wheel"
    ];
    settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
      persistent = true;
    };
    optimise = {
      automatic = true;
      persistent = true;
    };
  };

  environment.systemPackages = with pkgs; [
    iw
    git
    usbutils
    speedtest-cli
    btop
    htop
    dig
    samba # for smbpasswd
  ];

  i18n =
    let
      en_us = "en_US.UTF-8";
      de_de = "de_DE.UTF-8";
    in
    {
      defaultLocale = en_us;
      extraLocaleSettings = {
        LC_ADDRESS = de_de;
        LC_IDENTIFICATION = de_de;
        LC_MEASUREMENT = de_de;
        LC_MONETARY = de_de;
        LC_NAME = de_de;
        LC_NUMERIC = en_us;
        LC_PAPER = de_de;
        LC_TELEPHONE = de_de;
        LC_TIME = de_de;
      };
    };

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "25.05";
}
