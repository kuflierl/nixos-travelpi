{ lib, config, ... }:
let
  jellyfin_cfg = config.services.jellyfin;
  jellyfin_media_dir = "/media/General-Media/jellyfin-media";
in
{
  services.samba = {
    enable = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = config.networking.hostName;
        "netbios name" = config.networking.hostName;
        "security" = "user";
        #"use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = lib.concatStringsSep " " [
          "192.168.10."
          "127.0.0.1"
          "localhost"
        ];
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "bad user";
      };
      "Jellyfin" = {
        "path" = jellyfin_media_dir;
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = lib.concatStringsSep " " [
          "kuflierl"
          "mflierl"
        ];
        "force user" = jellyfin_cfg.user;
        "force group" = jellyfin_cfg.group;
      };
    };
  };

  systemd.tmpfiles.rules = [
    "d ${jellyfin_media_dir} 755 ${jellyfin_cfg.user} ${jellyfin_cfg.group}"
  ];

  services.samba-wsdd.enable = true;
}
