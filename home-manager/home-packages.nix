{ pkgs, inputs, ... }: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # CLI utils
    brightnessctl
  ];
}
