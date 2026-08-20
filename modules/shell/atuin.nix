{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.atuin.enable {
      programs.atuin = {
        daemon.enable = true;
        flags = [
          # "--disable-up-arrow"
          "--disable-ai"
        ];
      };
    };
  };
}
