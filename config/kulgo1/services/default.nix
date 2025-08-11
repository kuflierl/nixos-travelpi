{ ... }:
{
  imports = [
    ./kea-dhcp.nix
    ./hostapd.nix
    ./blocky.nix
  ];

  services = {
    openssh.enable = true;
    resolved.enable = false;
  };
}
