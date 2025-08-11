{ ... }:
{
  imports = [
    ./dhcpd4.nix
    ./hostapd.nix
  ];

  services = {
    openssh.enable = true;
  };
}
