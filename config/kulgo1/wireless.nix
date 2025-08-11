{ config, ... }:
{
  networking.wireless = {
    enable = true;
    interfaces = [
      "wlan0"
    ];
    secretsFile = config.sops.templates."wifi_env".path;
    networks = {
      "@HOME1_SSID@" = {
        psk = "@HOME1_PSK@";
      };
    };
  };
}
