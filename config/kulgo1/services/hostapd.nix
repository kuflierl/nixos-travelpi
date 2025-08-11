{
  pkgs,
  lib,
  config,
  ...
}:
{
  # partial inspiration from https://github.com/ghostbuster91/nixos-router/blob/main/modules/nixos/hostapd.nix
  services.hostapd = {
    enable = true;
    radios = {
      "wlan0" = {
        band = "2g";
        countryCode = "DE";
        channel = 0; # ACS
        networks = {
          "wlan0" = {
            ssid = config.networking.hostName;
            authentication = {
              mode = "wpa3-sae"; # may need to enable compatablity mode
              saePasswordsFile = config.sops.secrets."access_points/unmetered/psk".path; # Use saePasswordsFile if possible.
            };
            settings = {
              bridge = "br-lan-u";
            };
          };
        };
      };
      "wlp1s0u1u1" = {
        band = "5g";
        countryCode = "DE";
        channel = 149; # ACS doesn't seem to work for whatever reason
        # see https://github.com/morrownr/USB-WiFi/discussions/420
        wifi4 = {
          enable = true;
          capabilities = [
            "LDPC"
            "HT40+" # "HT40-"
            "SHORT-GI-20"
            "SHORT-GI-40"
            "MAX-AMSDU-7935"
          ];
        };
        wifi5 = {
          enable = true;
          operatingChannelWidth = "80"; # or "20or40"
          capabilities = [
            "MAX-MPDU-11454"
            "RXLDPC"
            "SHORT-GI-80"
            "TX-STBC-2BY1"
            "SU-BEAMFORMEE"
            "MU-BEAMFORMEE"
            "HTC-VHT"
          ];
        };
        networks = {
          "wlp1s0u1u1" = {
            ssid = config.networking.hostName;
            authentication = {
              mode = "wpa3-sae"; # may need to enable compatablity mode
              saePasswordsFile = config.sops.secrets."access_points/unmetered/psk".path; # Use saePasswordsFile if possible.
            };
            # fake bsside to satisfy module assertion
            # overided by ddynamicConfigScripts
            bssid = "00:00:00:00:00:00";
            settings = {
              bridge = "br-lan-u";
            };
            dynamicConfigScripts = {
              "20-bssidFile" = pkgs.writeShellScript "bssid-file" ''
                HOSTAPD_CONFIG_FILE=$1
                grep -v '\s*#' ${lib.escapeShellArg config.sops.secrets."access_points/unmetered/bssid".path} \
                  | sed 's/^/bssid=/' >> "$HOSTAPD_CONFIG_FILE"
              '';
            };
          };
          "wlp1s0u1u1-1" = {
            ssid = "${config.networking.hostName}-metered";
            authentication = {
              mode = "wpa3-sae";
              saePasswordsFile = config.sops.secrets."access_points/metered/psk".path;
            };
            # fake bsside to satisfy module assertion
            # overided by ddynamicConfigScripts
            bssid = "00:00:00:00:00:00";
            settings = {
              bridge = "br-lan-m";
            };
            dynamicConfigScripts = {
              "20-bssidFile" = pkgs.writeShellScript "bssid-file" ''
                HOSTAPD_CONFIG_FILE=$1
                grep -v '\s*#' ${lib.escapeShellArg config.sops.secrets."access_points/metered/bssid".path} \
                  | sed 's/^/bssid=/' >> "$HOSTAPD_CONFIG_FILE"
              '';
            };
          };
        };
      };
    };
  };
}
