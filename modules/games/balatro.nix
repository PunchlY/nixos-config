{
  nixpkgs.config = {
    allowUnfreePackages = [
      "balatro"
      "Balatro.exe"
    ];
  };

  flake.modules.homeManager.base = {
    config,
    pkgs,
    lib,
    ...
  }: {
    programs.steam.config = lib.mkIf config.programs.steam.config.enable {
      apps.Balatro = {
        enable = lib.mkDefault false;
        id = 2379780;
        launchOptions.preHook = ''
          export XDG_DATA_HOME="$STEAM_COMPAT_DATA_PATH/pfx/drive_c/users/steamuser/AppData/Roaming"
          game_command=("${pkgs.balatro}/bin/balatro")
        '';
      };
      nonSteamApps."Balatro Mod Manager" = {
        enable = config.programs.steam.config.apps.Balatro.enable;
        target = pkgs.balatro-mod-manager;
        desktopEntry.enable = false;
      };
    };
  };
}
