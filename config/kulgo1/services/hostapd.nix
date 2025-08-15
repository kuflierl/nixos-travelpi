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
      "wlp1s0u1" = {
        band = "2g";
        countryCode = "DE";
        channel = 9; # ACS
        networks = {
          "wlp1s0u1" = {
            ssid = config.networking.hostName;
            authentication = {
              mode = "wpa3-sae-transition"; # may need to enable compatablity mode
              saePasswordsFile = config.sops.secrets."access_points/unmetered/psk".path; # Use saePasswordsFile if possible.
              wpaPasswordFile = config.sops.secrets."access_points/unmetered/psk".path;
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
                grep -v '\s*#' ${lib.escapeShellArg config.sops.secrets."access_points/unmetered/bssid2".path} \
                  | sed 's/^/bssid=/' >> "$HOSTAPD_CONFIG_FILE"
              '';
            };
          };
         # "wlp1s0u1u1-1" = {
         #   ssid = "${config.networking.hostName}-m";
         #   authentication = {
         #     mode = "wpa3-sae"; # may need to enable compatablity mode
         #     saePasswordsFile = config.sops.secrets."access_points/metered/psk".path; # Use saePasswordsFile if possible.
         #   };
         #   # fake bsside to satisfy module assertion
         #   # overided by ddynamicConfigScripts
         #   bssid = "00:00:00:00:00:00";
         #   settings = {
         #     bridge = "br-lan-m";
         #   };
         #   dynamicConfigScripts = {
         #     "20-bssidFile" = pkgs.writeShellScript "bssid-file" ''
         #       HOSTAPD_CONFIG_FILE=$1
         #       grep -v '\s*#' ${lib.escapeShellArg config.sops.secrets."access_points/metered/bssid2".path} \
         #         | sed 's/^/bssid=/' >> "$HOSTAPD_CONFIG_FILE"
         #     '';
         #   };
         # };
        };
      };
      "wlan0" = {
        band = "5g";
        countryCode = "DE";
        channel = 0; # ACS
        # see https://github.com/morrownr/USB-WiFi/discussions/420
        # see https://discourse.nixos.org/t/creating-a-raspberry-pi-5-access-point-with-pi-hole/61331/3
        wifi4 = {
          enable = true;
          capabilities = [
            "HT40+" # "HT40-"
            "SHORT-GI-20"
            "SHORT-GI-40"
            "MAX-AMSDU-3839"
            "DSSS_CCK-40"
          ];
        };
        wifi5 = {
          enable = true;
          operatingChannelWidth = "80"; # or "20or40"
          capabilities = [
            "MAX-MPDU-3895"
            "SHORT-GI-80"
            "SU-BEAMFORMEE"
            #"MU-BEAMFORMEE"
          ];
        };
        networks = {
          "wlan0" = {
            ssid = "${config.networking.hostName}-5G";
            authentication = {
              mode = "wpa2-sha1"; # rpi doesn't seem to support anything higher
              wpaPasswordFile = config.sops.secrets."access_points/unmetered/psk".path; # Use saePasswordsFile if possible.
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
          #          "wlp1s0u1u1-1" = {
          #            ssid = "${config.networking.hostName}-metered";
          #            authentication = {
          #              mode = "wpa3-sae";
          #              saePasswordsFile = config.sops.secrets."access_points/metered/psk".path;
          #            };
          #            # fake bsside to satisfy module assertion
          #            # overided by ddynamicConfigScripts
          #            bssid = "00:00:00:00:00:00";
          #            settings = {
          #              bridge = "br-lan-m";
          #            };
          #            dynamicConfigScripts = {
          #              "20-bssidFile" = pkgs.writeShellScript "bssid-file" ''
          #                HOSTAPD_CONFIG_FILE=$1
          #                grep -v '\s*#' ${lib.escapeShellArg config.sops.secrets."access_points/metered/bssid".path} \
          #                  | sed 's/^/bssid=/' >> "$HOSTAPD_CONFIG_FILE"
          #              '';
          #            };
          #          };
        };
      };
    };
  };
}
