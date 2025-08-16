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
      "wlp1s0u1u1" = {
        band = "2g";
        countryCode = "DE";
        channel = 9; # ACS
        networks = {
          "wlp1s0u1u1" = {
            ssid = config.networking.hostName;
            authentication = {
              mode = "wpa3-sae-transition"; # may need to enable compatablity mode
              saePasswordsFile = config.sops.secrets."access_points/unmetered/psk".path; # Use saePasswordsFile if possible.
              wpaPasswordFile = config.sops.secrets."access_points/unmetered/psk".path;
            };
            settings = {
              bridge = "br-lan";
            };
          };
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
            settings = {
              bridge = "br-lan";
            };
          };
        };
      };
    };
  };
}
