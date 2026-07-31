{ lib, ... }:

{
  imports = [
    ./locales.nix
    ./minimal.nix
    ./headless.nix
  ];
  # enable flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  # timezone
  time.timeZone = lib.mkDefault "Europe/Berlin";
}
