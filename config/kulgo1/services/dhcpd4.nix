{ }:
{
  services.dhcpd4 = {
    enable = true;
    interfaces = [
      "br-lan-u"
      "br-lan-m"
    ];
    extraConfig = ''
      option domain-name-servers 192.168.10.1;
      option subnet-mask 255.255.255.0;

      subnet 192.168.10.0 netmask 255.255.255.0 {
        option broadcast-address 192.168.10.255;
        option routers 192.168.10.1;
        interface br-lan-u;
        range 192.168.10.128 10.1.1.254;
      }

      subnet 192.168.11.0 netmask 255.255.255.0 {
        option broadcast-address 192.168.11.255;
        option routers 192.168.11.1;
        interface br-lan-m;
        range 192.168.11.128 192.168.11.254;
      }
    '';
  };
}
