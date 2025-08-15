{ ... }:
{
  services.jellyfin =
    let
      external-drive = "/media/General-Media";
    in
    {
      enable = true;
      openFirewall = true;
      dataDir = "${external-drive}/jellyfin";
      cacheDir = "${external-drive}/cache/jellyfin";
    };
}
