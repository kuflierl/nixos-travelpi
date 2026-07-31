_: {
  imports = [
    ./misc
    # ./users
    # ./networking
    # ./services
  ];

  # set perms for nix daemon
  nix.settings = rec {
    trusted-users = [ "@wheel" ];
    allowed-users = trusted-users;
    # storage optimisation
    auto-optimise-store = false; # immense performance penalty
  };

  nix.optimise.automatic = true;
}
