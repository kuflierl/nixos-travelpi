{ config, ... }:

{
  # Wireless Access Point Daemon Configuration
  services.hostapd = {
    enable = true;
    radios = {
      # ------------------------------------------------------------------
      # Onboard Broadcom/Cypress CYW43455 - 2.4 GHz Access Point
      # ------------------------------------------------------------------
      "wlan0" = {
        band = "2g";
        countryCode = "DE";

        # Channel 6 selected (Non-overlapping 2437 MHz).
        channel = 6;

        # IEEE 802.11n (Wi-Fi 4) Configuration
        wifi4 = {
          enable = true;
          capabilities = [
            "SHORT-GI-20"
            "MAX-AMSDU-3839"
            "DSSS_CCK-40"
          ];
        };

        networks = {
          "wlan0" = {
            ssid = config.networking.hostName;

            # Security: WPA3-SAE / WPA2-PSK Transition Mode
            authentication = {
              mode = "wpa2-sha1";
              saePasswordsFile = config.sops.secrets."access_points/psk".path;
              wpaPasswordFile = config.sops.secrets."access_points/psk".path;
            };

            settings = {
              bridge = "br-lan";

              # Enforce WMM (Wi-Fi Multi-Media) for 802.11n compliance
              wmm_enabled = 1;

              # Explicitly disable PMF on Broadcom wlan0 to prevent firmware rejection
              ieee80211w = 0;

              # Tuning for mobile travel clients
              disassoc_low_ack = 1;
            };
          };
        };
      };

      # ------------------------------------------------------------------
      # External Realtek RTL8812BU (2AZES-AC1L) - 5 GHz Access Point
      # ------------------------------------------------------------------
      "wlp1s0u1u1" = {
        band = "5g";
        countryCode = "DE";

        # Channel 36 selected (5180 MHz - UNII-1 non-DFS band for travel stability)
        channel = 36;

        # IEEE 802.11n (Wi-Fi 4) 5 GHz Capabilities
        wifi4 = {
          enable = true;
          capabilities = [
            "HT40+"
            "SHORT-GI-20"
            "SHORT-GI-40"
            "MAX-AMSDU-7935"
            "LDPC"
          ];
        };

        # IEEE 802.11ac (Wi-Fi 5) 80 MHz VHT Configuration
        wifi5 = {
          enable = true;
          operatingChannelWidth = "80";
          capabilities = [
            "MAX-MPDU-11454"
            "RXLDPC"
            "SHORT-GI-80"
            "TX-STBC-2BY1"
            "RX-STBC1"
            "SU-BEAMFORMEE"
            "MU-BEAMFORMEE"
            "MAX-A-MPDU-LEN-EXP7"
          ];
        };

        networks = {
          "wlp1s0u1u1" = {
            ssid = "${config.networking.hostName}-5G";

            # Security: WPA3-SAE / WPA2-PSK Transition Mode
            authentication = {
              mode = "wpa3-sae-transition";
              saePasswordsFile = config.sops.secrets."access_points/psk".path;
              wpaPasswordFile = config.sops.secrets."access_points/psk".path;
            };

            settings = {
              bridge = "br-lan";

              # Enforce WMM for 802.11ac VHT operation
              wmm_enabled = 1;

              # PMF Optional (Required for WPA3 Transition Mode)
              ieee80211w = 1;

              # VHT Center Frequency calculation for Channel 36 at 80 MHz width
              # (Center frequency index 42 = 5210 MHz)
              vht_oper_centr_freq_seg0_idx = 42;
            };
          };
        };
      };
    };
  };
}
