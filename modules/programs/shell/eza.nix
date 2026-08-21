{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: {
    config = lib.mkIf config.programs.eza.enable {
      programs.eza = {
        enableBashIntegration = true;
        colors = "auto";
        icons = "auto";
        git = true;
        extraOptions = [
          "--classify=auto"
          "--group-directories-first"
          "--hyperlink=auto"
        ];
      };
    };
  };
}
