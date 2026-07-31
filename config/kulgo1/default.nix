{ lib, pkgs, ... }: {
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

  security.sudo.wheelNeedsPassword = false;

  system.stateVersion = "25.05";
}
