{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    mkcert
    nssTools
  ];

  home.activation.mkcert = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    # mkcert использует certutil для NSS-хранилищ Firefox/Chromium.
    export PATH="${pkgs.nssTools}/bin:${pkgs.mkcert}/bin:$PATH"

    # Chromium M146+ по умолчанию использует:
    # ~/.local/share/pki/nssdb
    #
    # mkcert пока ожидает старый путь ~/.pki/nssdb.
    # Если нового/старого хранилища ещё нет, создаём legacy DB,
    # чтобы Chromium использовал её и mkcert смог установить CA.
    if [ ! -f "$HOME/.local/share/pki/nssdb/cert9.db" ] \
      && [ ! -f "$HOME/.pki/nssdb/cert9.db" ]; then

      mkdir -p "$HOME/.pki/nssdb"

      run certutil \
        -d "sql:$HOME/.pki/nssdb" \
        -N \
        --empty-password
    fi

    # Устанавливаем mkcert CA в NSS/system stores.
    run mkcert -install
  '';
}
