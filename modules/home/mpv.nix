{
  nixosConfig,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (nixosConfig.theme) font colors;
in {
  config = lib.mkIf config.programs.mpv.enable {
    programs.yt-dlp = {
      enable = true;
      settings = {
        sub-langs = "all";
      };
    };

    programs.mpv = {
      config = with colors; {
        gpu-context = "auto";
        hwdec = "auto-safe";
        vo = "gpu-next";
        profile = "gpu-hq";
        hwdec-codecs = "all";

        keep-open = true;
        idle = true;
        slang = builtins.concatStringsSep "," [
          "zh-Hans"
          "zh-CN"
          "zh"
          "chi"
          "zh-Hant"
          "zh-TW"
          "zh-HK"
          "en-US"
          "en-GB"
          "en"
        ];

        osc = false;
        osd-bar = false;

        background-color = surface.hex;
        osd-back-color = surface.hex;
        osd-border-color = surface.hex;
        osd-color = on_surface.hex;
        osd-shadow-color = shadow.hex;

        osd-font = font.name;
        sub-font = font.name;

        force-seekable = true;
        cache = true;
        cache-pause-initial = false;
        cache-secs = 10;
        demuxer-readahead-secs = 15;
        demuxer-max-bytes = "256MiB";
        demuxer-max-back-bytes = "64MiB";
      };
      profiles.bilibili = {
        profile-cond = "path:match('https://www.bilibili.com')~=nil or path:match('https://bilibili.com')~=nil";
        profile-restore = "copy";
        ytdl-raw-options = "cookies-from-browser=chrome,sub-lang=[all,-danmaku],write-sub=";
      };
      profiles.youtube = {
        profile-cond = "path:match('https://www.youtube.com')~=nil";
        profile-restore = "copy";
        ytdl-format = "best";
      };

      scripts = with pkgs; [
        mpvScripts.mpris
        mpvScripts.uosc
        mpvScripts.reload
        mpvScripts.sponsorblock
        mpvScripts.quality-menu
        mpvScripts.thumbfast

        (mpvScripts.buildLua rec {
          pname = "uosc-danmaku";
          version = "v2.0.0";
          src = fetchFromGitHub {
            owner = "Tony15246";
            repo = "uosc_danmaku";
            rev = version;
            sha256 = "sha256-r4HcrDh4iW8ErfClfX1gkEWp7lVKbLE88fpj3tjYBAI=";
          };
          scriptPath = ".";
          scriptName = "uosc_danmaku";
          passthru.scriptName = scriptName;
        })
      ];

      scriptOpts.ytdl_hook.ytdl_path = lib.getExe config.programs.yt-dlp.package;

      scriptOpts.uosc = {
        timeline_style = "bar";
        top_bar_controls = false;
        timeline_size = 24;
        scale = 1.5;
        controls = builtins.concatStringsSep "," [
          "menu"
          "gap"
          "<video,audio>subtitles"
          "<has_audio>audio-device"
          "<has_many_audio>audio"
          "<has_many_video>video"
          "<has_many_edition>editions"
          "<stream>stream-quality"
          "<video>button:danmaku_menu"
          "<video>cycle:toggle_on:show_danmaku@uosc_danmaku:on=toggle_on/off=toggle_off?弹幕开关"
          "space"
          "<video,audio>speed"
          "space"
          "shuffle"
          "loop-playlist"
          "loop-file"
          "gap"
          "prev"
          "items"
          "next"
          "gap"
          "fullscreen"
        ];
        languages = "slang,en";

        color = with colors;
          lib.concatMapAttrsStringSep "," (name: value: "${name}=${value}") {
            foreground = on_surface.hex_stripped;
            foreground_text = surface.hex_stripped;
            background = surface.hex_stripped;
            background_text = on_surface.hex_stripped;
            success = green.hex_stripped;
            error = error.hex_stripped;
          };
      };

      scriptOpts.uosc_danmaku = {
        merge_tolerance = 3;
        displayarea = 0.75;
        max_screen_danmaku = 60;
      };

      scriptOpts.reload = {
        reload_key_binding = "Ctrl+r";
      };

      scriptOpts.thumbfast = {
        network = true;
        hwdec = true;
      };
    };
  };
}
