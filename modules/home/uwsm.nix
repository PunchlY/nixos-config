{
  nixosConfig,
  config,
  lib,
  ...
}: let
  cfg = config.programs.uwsm;

  variablesType = with lib.types;
    attrsOf (
      nullOr (oneOf [
        (listOf (oneOf [
          int
          str
          path
        ]))
        int
        str
        path
      ])
    );
  variablesApply = let
    toStr = v:
      if lib.isPath v
      then "${v}"
      else toString v;
  in
    attrs:
      lib.mapAttrs (_n: v:
        if lib.isList v
        then lib.concatMapStringsSep ":" toStr v
        else toStr v) (
        lib.filterAttrs (_n: v: v != null) attrs
      );

  generator = attrs:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList (
        key: value: "export ${lib.escapeShellArg key}=${lib.escapeShellArg value}"
      )
      attrs
    );
in {
  options.programs.uwsm = {
    enable =
      lib.mkEnableOption "uwsm"
      // {
        default = nixosConfig.programs.uwsm.enable;
      };
    env = lib.mkOption {
      type = variablesType;
      apply = variablesApply;
      default = {};
    };
    desktopEnv = lib.mkOption {
      type = lib.types.attrsOf variablesType;
      apply = lib.mapAttrs (_desktop: variablesApply);
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile =
      lib.mapAttrs' (
        desktop: attrs:
          lib.nameValuePair "uwsm/env-${desktop}" {
            text = generator attrs;
          }
      )
      cfg.desktopEnv
      // {
        "uwsm/env" = {
          text = generator cfg.env;
        };
      };
  };
}
