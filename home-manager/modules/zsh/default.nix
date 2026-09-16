{ pkgs, config, ... }: {

  home.packages = with pkgs; [
    zsh-powerlevel10k
  ];

  home.file.".p10k.zsh".source = ./.p10k.zsh;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history.size = 10000;
    history.path = "${config.xdg.dataHome}/zsh/history";

    oh-my-zsh = {
      enable = true;
    };

    initExtra = ''
      rebuild-nixos() {
        sudo nixos-rebuild switch --flake ~/nixos#''$1
      }

      home-manager-rebuild() {
        home-manager switch --flake ~/nixos#''$1
      }

      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';
  };
}
