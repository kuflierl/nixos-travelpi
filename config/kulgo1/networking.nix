{ ... }:
{
  # inspired from the following:
  # https://github.com/ghostbuster91/blogposts/blob/a2374f0039f8cdf4faddeaaa0347661ffc2ec7cf/router2023-part2/main.md

  networking = {
    useNetworkd = true;
    useDHCP = false;

    nat.enable = false;
    firewall.enable = false;

    nftables = {
      enable = true;
      ruleset = ''
                table inet filter {
                  chain input {
                    type filter hook input priority 0; policy drop;

                    iifname { "br-lan-u", "br-lan-m" } accept comment "Allow local network to access everything"
                    iifname { "br-wan-u", "br-wan-m" } tcp dport { ssh } accept comment "Allow ssh access from wan for debuging"
                    iifname { "br-wan-u", "br-wan-m" } ct state { established, related } accept comment "Allow established traffic"
                    iifname { "br-wan-u", "br-wan-m" } icmp type { echo-request, destination-unreachable, time-exceeded } counter accept comment "Allow ICMP from WAN"
                    iifname { "br-wan-u", "br-wan-m" } counter drop comment "Drop all other traffic from WAN"
                    iifname "lo" accept comment "Accept everything from Loopback"
                  }
                  chain forward {
                    type filter hook forward priority filter; policy drop;

                    iifname { "br-lan-u", "br-lan-m" } oifname { "br-lan-u", "br-lan-m" } accept comment "Allow trusted LAN to LAN"
                    iifname { "br-lan-u", "br-lan-m" } oifname { "br-wan-u" } accept comment "Allow trusted LAN to WAN (unmetered)"
                    iifname { "br-lan-u" } oifname { "br-wan-m" } accept comment "Allow trusted LAN to WAN (metered)"
                    iifname { "br-wan-u" } oifname { "br-lan-u", "br-lan-m" } ct state { established, related } accept comment "Allow established back to LANs (unmetered)"
                    iifname { "br-wan-m" } oifname { "br-lan-u" } ct state { established, related } accept comment "Allow established back to LANs (metered)"
                  }
                }
                table ip nat {
                  chain postrouting {
                    type nat hook postrouting priority 100; policy accept;
                    oifname { "br-wan-u", "br-wan-m" } masquerade
                  }
                }
                table ip6 filter {
        	        chain input {
                    type filter hook input priority 0; policy drop;
                  }
                  chain forward {
                    type filter hook forward priority 0; policy drop;
                  }
                }
      '';
    };
  };

  systemd.network = {
    # enable systemd networkd for static interfaces
    enable = true;

    netdevs =
      let
        bridge_list = [
          "lan-m"
          "lan-u"
          "wan-m"
          "wan-u"
        ];
        bridge_template = brname: {
          name = "10-br-${brname}";
          value.netdevConfig = {
            Kind = "bridge";
            Name = "br-${brname}";
          };
        };
      in
      builtins.listToAttrs (builtins.map (bridge_template) bridge_list);

    networks = {
      "20-end0" = {
        matchConfig.Name = "end0";
        linkConfig.RequiredForOnline = "enslaved";
        networkConfig.Bridge = "br-wan-u";
        networkConfig.ConfigureWithoutCarrier = true;
      };
      "21-enp1s0u1u4" = {
        matchConfig.Name = "enp1s0u1u4";
        linkConfig.RequiredForOnline = false;
        networkConfig.Bridge = "br-wan-m";
        networkConfig.ConfigureWithoutCarrier = false;
      };
      #"21-wlan0" = {
      #  matchConfig.Name = "wlan0";
      #  linkConfig.RequiredForOnline = "enslaved";
      #  networkConfig.Bridge = "br-wan-u";
      #  networkConfig.ConfigureWithoutCarrier = true;
      #};
      #"22-wlan1" = {
      #  matchConfig.Name = "wlan1";
      #  linkConfig.RequiredForOnline = "enslaved";
      #  networkConfig.Bridge = "br-lan-"
      #};
      "30-br-wan-u" = {
        matchConfig.Name = "br-wan-u";
        networkConfig.DHCP = true;
        networkConfig.IPv6AcceptRA = true;
        networkConfig.IPv4Forwarding = true;
        networkConfig.IPv6Forwarding = false; # for now
        linkConfig.RequiredForOnline = true;
        dhcpV4Config.RouteMetric = 600;
      };
      "31-br-wan-m" = {
        matchConfig.Name = "br-wan-m";
        networkConfig.DHCP = true;
        networkConfig.IPv6AcceptRA = true;
        networkConfig.IPv4Forwarding = true;
        networkConfig.IPv6Forwarding = false; # for now
        linkConfig.RequiredForOnline = false;
        dhcpV4Config.RouteMetric = 400;
      };
      "32-br-lan-u" = {
        matchConfig.Name = "br-lan-u";
        networkConfig.DHCP = false;
        networkConfig.IPv4Forwarding = true;
        networkConfig.IPv6Forwarding = false; # for now
        bridgeConfig = { };
        address = [
          "192.168.10.1/24"
        ];
        linkConfig.RequiredForOnline = true;
        networkConfig.ConfigureWithoutCarrier = true;
      };
      "33-br-lan-m" = {
        matchConfig.Name = "br-lan-m";
        networkConfig.DHCP = false;
        networkConfig.IPv4Forwarding = true;
        networkConfig.IPv6Forwarding = false; # for now
        bridgeConfig = { };
        address = [
          "192.168.11.1/24"
        ];
        linkConfig.RequiredForOnline = true;
        networkConfig.ConfigureWithoutCarrier = true;
      };
    };
  };
}
