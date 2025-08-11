{ ... }:
{
  services.kea.dhcp4 = {
    enable = true;
    settings = {
      interfaces-config = {
        interfaces = [ "br-lan-u" "br-lan-m" ];
      };
      lease-database = {
        name = "/var/lib/kea/dhcp4.leases";
        persist = true;
        type = "memfile";
        lfc-interval = 1800;
        max-row-errors = 100;
      };
      rebind-timer = 2000;
      renew-timer = 1000;
      valid-lifetime = 4000;
      subnet4 = [
        {
          id = 1;
          subnet = "192.168.10.0/24";
          interface = "br-lan-u";
          pools = [ { pool = "192.168.10.128 - 192.168.10.254"; } ];
          option-data = [
            {
              name = "domain-name-servers";
              data = "192.168.10.1";
              always-send = true;
            }
            {
              name = "routers";
              data = "192.168.10.1";
              always-send = true;
            }
          ];
        }
        {
          id = 2;
          subnet = "192.168.11.0/24";
          interface = "br-lan-m";
          pools = [ { pool = "192.168.11.128 - 192.168.11.254"; } ];
          option-data = [
            {
              name = "domain-name-servers";
              data = "192.168.11.1";
              always-send = true;
            }
            {
              name = "routers";
              data = "192.168.11.1";
              always-send = true;
            }
          ];
        }
      ];
    };
  };
}
