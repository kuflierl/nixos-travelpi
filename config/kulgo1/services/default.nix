{ ... }:
{
  imports = [
    ./kea-dhcp.nix
    ./hostapd.nix
  ];

  services = {
    openssh.enable = true;
  };
}
