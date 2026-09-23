{ pkgs, inputs, ... }: {
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [

    google-chrome
    inputs.yandex-browser.packages.x86_64-linux.yandex-browser-stable
    zed-editor
    kdePackages.kdenlive

    # CLI utils
    brightnessctl
    zip
    unzip

    # Docker / DDEV
    ddev
    docker-buildx
    docker-compose
  ];

  home.file = {
    ".docker/cli-plugins/docker-buildx" = {
      source =
        "${pkgs.docker-buildx}/libexec/docker/cli-plugins/docker-buildx";
    };

    ".docker/cli-plugins/docker-compose" = {
      source =
        "${pkgs.docker-compose}/libexec/docker/cli-plugins/docker-compose";
    };
  };
}
