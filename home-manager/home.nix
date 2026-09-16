{ homeStateVersion, user, ... }: {
  imports = [
    ./modules.nix
    ./home-packages.nix
  ];

  home = {
    username = user;
    homeDirectory = "/home/${user}";
    stateVersion = homeStateVersion;
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}
