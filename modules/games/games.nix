{
  flake.modules.homeManager.base = {lib, ...}: {
    imports =
      [
        (lib.mkAliasOptionModule ["games" "steam"] ["services" "steam"])
      ]
      ++ lib.mapAttrsToList (name: programs: lib.mkAliasOptionModule ["games" name] ["programs" programs]) {
        ksre = "katawa-shoujo-re-engineered";
        minecraft = "prismlauncher";
        retroarch = "retroarch";
      };
  };
}
