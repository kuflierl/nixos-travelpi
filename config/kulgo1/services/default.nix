{ ... }:
{
  imports = [
    ./kea-dhcp.nix
    ./hostapd.nix
    ./blocky.nix
    ./jellyfin.nix
  ];

  services = {
    openssh.enable = true;
    resolved.enable = false;
  };
}
