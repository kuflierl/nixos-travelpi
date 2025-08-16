{ config, lib, ... }:
{
  users =
    let
      jellyfin_cfg = config.services.jellyfin;
    in
    {
      mutableUsers = false;
      users."kuflierl" = {
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC6YiltO91AlndYCt8gmu6uhtnrVLW6D1Wm0UunQgdlf5ZVyTclvIiBI34S/iPwkU5JsMorpsfwOZI+natL0NcJQ2Dgoax7yBDov3d2viU3yRJgqaSGsDDfIhS968shUwYg3ZOgp4jb1IL2De0FZqxgJhXRuDe8uR13joCFwbzm+l8WBg5SKc+WH3BXIVo8LM9t1lsQ6Xuc8tjYfCksbFhkmMsto/sYxhvcbrHRCbNTgeN1zwYIW24ewpD/phGKKPivgUSsNyYLz5cib3qfje1lfyblfxKRd6giS84XSGOWsXHTk0TCI/jGjk1Z59fM0p/4RjJDObX/YE2Y5xqKARZEvE0njo1A8gkNpewIrBbpJMuCrXVEpRJQhFTyaAm2IytP/9SzvWxJ3vXBLCgcma9thGw3l1aX6oUjS8OK8ZZPoJrxrpyL42cK/i4HIltZy2AuM3OgW1i3yA0PxoDDXZMbTGv5/icH1UrMJUEU2yrQrrDp/mBhNFYwNYMrz5mZOJE= private"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGNZCmEzMtQ9q/p8PbyITR3F4FYWdnYj6pNLgwb8k5BV kuflierl@kul6"
        ];
      };
      users."mflierl" = {
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDw2wn8wz/BNwbCtDu5cbsyVFuCRe/lnsmVRsj1GaRIXoGRAAZ9IhPOkQRDfqdGi0Tu5vx7cByBn3euZnbQMSVcys9dj76sf87vz8vckO0iEF3blzeXjpXTBjJEjDRVyk7xZewqYRsAl7G+QvBISqFlSIZh1u3MoD63dokqatdAOsWJ6LkCNePrx5XTLvHYeh0IA/Oib/PYkXRGd089KMOxxzWU15k6XaF7msDCj7HfFS0liqJJ2PfOeEBQjEyG75zSGzlFqas8XooCG3/VQ+eHB22yH7vkQo47/nuzdGqBK3Fut1IhxXbcS1uKAbswLdOU+KcuCbEQ7DCAL2hLbIH32yvn0xwdpT5kj8rZYDWMdNWUtpyOVG5tgSyvlkrLQJO3CwGggWZZN8RdaEff/glIQRxqMKkJ8Sp2xwPB06PWQUDqJCCpkvdlj96wSIsBaqZGWMIwiSa8+irt5PgalcExvmsxw4peLo7bEkXDFM129rL5UPc1O+TYRNCKTGV+92c= mflierl@msl4.local"
        ];
      };
      users."${jellyfin_cfg.user}" = lib.mkIf jellyfin_cfg.enable {
        uid = 994; # previous known good value
      };
    };
}
