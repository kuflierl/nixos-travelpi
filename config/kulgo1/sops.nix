{ config, ... }:
{
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ../../secrets/kulgo1.yaml;
    defaultSopsFormat = "yaml";
    secrets = {
      "access_points/metered/psk" = { };
      "access_points/metered/bssid" = { };
      "access_points/unmetered/psk" = { };
      "access_points/unmetered/bssid" = { };
      #  "wifi/home1/ssid" = {};
      #  "wifi/home1/psk" = {};
    };
    #templates = {
    #  "wifi_env".content = ''
    #    HOME1_SSID = "${config.sops.placeholder."wifi/home1/ssid"}"
    #    HOME1_PSK = "${config.sops.placeholder."wifi/home1/psk"}"
    #  '';
    #};
  };
}
