_: {
  networking.firewall = {
    allowedTCPPorts = [ 53 ];
    allowedUDPPorts = [ 53 ];
  };

  services.blocky = {
    enable = true;

    # https://0xerr0r.github.io/blocky/latest/configuration
    settings = {

      upstreams.groups.default = [
        "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
        "tcp-tls:1.1.1.1:853"
        "https://dns10.quad9.net/dns-query"
        "tcp-tls:dns10.quad9.net"
        "https://freedns.controld.com/p0"
        "tcp-tls:p0.freedns.controld.com"
        "https://dns.mullvad.net/dns-query"
        "tcp-tls:dns.mullvad.net"
      ];

      # We currently only have IPv4 upstream
      # connectIPVersion = "v4";

      customDNS = {
        # customTTL = "1h";
      };

      conditional.mapping = {
        "lan" = "192.168.1.1";
        "1.168.192.in-addr.arpa" = "192.168.1.1";
      };

      # Enable blocking of certain domains.
      blocking = {
        denylists = {
          # Adblocking + Malware
          ads = [
            "https://kuflierl.github.io/Blocklists/resources/Hosts/advertising.host"
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
            "https://adaway.org/hosts.txt"
            "https://v.firebog.net/hosts/AdguardDNS.txt"
            "https://v.firebog.net/hosts/Admiral.txt"
            "https://raw.githubusercontent.com/anudeepND/blacklist/master/adservers.txt"
            "https://v.firebog.net/hosts/Easylist.txt"
            "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/UncheckyAds/hosts"
            "https://raw.githubusercontent.com/bigdargon/hostsVN/master/hosts"
          ];
          tracking = [
            "https://kuflierl.github.io/Blocklists/resources/Hosts/tracking.host"
            "https://v.firebog.net/hosts/Easyprivacy.txt"
            "https://v.firebog.net/hosts/Prigent-Ads.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.2o7Net/hosts"
            "https://raw.githubusercontent.com/crazy-max/WindowsSpyBlocker/master/data/hosts/spy.txt"
            "https://hostfiles.frogeye.fr/firstparty-trackers-hosts.txt"
          ];
          suspicius = [
            "https://kuflierl.github.io/Blocklists/resources/Hosts/trashware.host"
            "https://raw.githubusercontent.com/PolishFiltersTeam/KADhosts/master/KADhosts.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Spam/hosts"
            "https://v.firebog.net/hosts/static/w3kbl.txt"
          ];
          malicious = [
            "https://raw.githubusercontent.com/DandelionSprout/adfilt/master/Alternate%20versions%20Anti-Malware%20List/AntiMalwareHosts.txt"
            "https://v.firebog.net/hosts/Prigent-Crypto.txt"
            "https://raw.githubusercontent.com/FadeMind/hosts.extras/master/add.Risk/hosts"
            "https://phishing.army/download/phishing_army_blocklist_extended.txt"
            "https://gitlab.com/quidsup/notrack-blocklists/raw/master/notrack-malware.txt"
            "https://raw.githubusercontent.com/Spam404/lists/master/main-blacklist.txt"
            "https://raw.githubusercontent.com/AssoEchap/stalkerware-indicators/master/generated/hosts"
            "https://urlhaus.abuse.ch/downloads/hostfile/"
            "https://lists.cyberhost.uk/malware.txt"
          ];
          gambling = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/gambling-only/hosts"
          ];
          adult = [
            "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/porn-only/hosts"
            "https://blocklistproject.github.io/Lists/porn.txt"
          ];
          # fakenews = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/fakenews-only/hosts" ];
          # social = [ "https://raw.githubusercontent.com/StevenBlack/hosts/master/alternates/social-only/hosts" ];

          youtube = [ "https://kuflierl.github.io/Blocklists/resources/Hosts/Special/block-youtube.host" ];
        };

        # Configure what block categories are used
        clientGroupsBlock =
          let
            default = [
              "default"
              "ads"
              "tracking"
              "suspicius"
              "malicious"
            ];
            kiara = default ++ [
              "adult"
              "gambling"
              "youtube"
            ];
          in
          {
            inherit default;
            "Galaxy-Tab-A8.lan" = kiara;
            "msl5.lan" = kiara;
          };
      };
      caching = {
        minTime = "5m";
        # maxTime = "30m";
        prefetching = false;
      };

      clientLookup = {
        upstream = "192.168.1.1";
      };

      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = [
        {
          upstream = "https://one.one.one.one/dns-query";
          ips = [ "1.1.1.1" ];
        }
        {
          upstream = "https://dns.mullvad.net/dns-query";
          ips = [ "194.242.2.2" ];
        }
        {
          upstream = "tcp-tls:dns10.quad9.net";
          ips = [ "9.9.9.10" ];
        }
      ];

      ports.dns = 53; # Port for incoming DNS Queries.
      ede.enable = true;

      dnssec.validate = true;
    };
  };
}
