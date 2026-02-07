{
  wechat,
  makeWrapper,
}:

wechat.overrideAttrs (super: {
    extraPreBwrapCmds = ''
      if [[ "''${WECHAT_DATA_DIR}" ]]; then
        WECHAT_DATA_DIR=$(readlink -f -- "''${WECHAT_DATA_DIR}")
      else
        XDG_DOCUMENTS_DIR="''${XDG_DOCUMENTS_DIR:-$(xdg-user-dir DOCUMENTS)}"
        if [[ -z "''${XDG_DOCUMENTS_DIR}" ]]; then
            echo 'Error: Failed to get XDG_DOCUMENTS_DIR, refuse to continue'
            exit 1
        fi
        WECHAT_DATA_DIR="''${XDG_DOCUMENTS_DIR}/WeChat_Data"
      fi

      XDG_DOWNLOAD_DIR="''${XDG_DOWNLOAD_DIR:-$(xdg-user-dir DOWNLOAD)}"

      WECHAT_HOME_DIR="''${WECHAT_DATA_DIR}/home"
      WECHAT_FILES_DIR="''${WECHAT_DATA_DIR}/xwechat_files"

      mkdir -p "''${WECHAT_FILES_DIR}"
      mkdir -p "''${WECHAT_HOME_DIR}"
      ln -snf "''${WECHAT_FILES_DIR}" "''${WECHAT_HOME_DIR}/xwechat_files"
    '';
    extraBwrapArgs = [
      "--tmpfs /home"
      "--tmpfs /root"
      ''--bind "''${WECHAT_HOME_DIR}" "''${HOME}"''
      ''--bind "''${WECHAT_FILES_DIR}"{,}''
      ''--ro-bind-try "''${XDG_DOWNLOAD_DIR}"{,}''
      "--chdir \${HOME}"
      # wechat-universal only supports xcb
      "--setenv QT_QPA_PLATFORM xcb"
      "--setenv QT_AUTO_SCREEN_SCALE_FACTOR 1"
      # use fcitx as IME
      "--setenv QT_IM_MODULE fcitx"
      "--setenv GTK_IM_MODULE fcitx"
    ];
    chdirToPwd = false;
    unshareNet = false;
    unshareIpc = true;
    unsharePid = true;
    unshareUts = true;
    unshareCgroup = true;
    privateTmp = true;
  }
)
