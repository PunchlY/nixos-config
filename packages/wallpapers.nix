{
  imagemagick,
  runCommand,
  fetchurl,
  stdenv,
  lib,
}:
let
  magick =
    args: input:
    let
      m = builtins.match "^(.*)\\.[^.]+$" input.name;
      name = if m == null then input.name else builtins.elemAt m 0;
    in
    runCommand "${name}.png" {
      src = input;
      nativeBuildInputs = [ imagemagick ];
      passthru = lib.mapAttrs (_: operation: operation input) (operations args);
    } "magick $src ${lib.escapeShellArgs args} $out";
  operations =
    args:
    lib.mapAttrs (_: args2: magick (args ++ args2)) {
      crop = [
        "-fuzz"
        "10%"
        "-trim"
        "+repage"
      ];
      blur = [
        "-blur"
        "0x8"
      ];
      adaptive-blur = [
        "-adaptive-blur"
        "0x8"
      ];
    };
in
with (operations [ ]);
rec {
  pixiv_68936009 = crop (fetchurl {
    url = "https://i.pixiv.re/img-original/img/2018/05/26/23/51/57/68936009_p0.jpg";
    sha256 = "sha256-s8eDdjoZaTWcSodD3xOQX6iGYHLa9sf9DnTw8Dzitgc=";
  });

  pixiv_67308965 = crop (fetchurl {
    url = "https://i.pixiv.re/img-original/img/2018/02/16/21/22/51/67308965_p0.jpg";
    sha256 = "sha256-eSYPZ8VKrKQYyVXpAmR27OfjdLJghuWxTuRr6LUEHGU=";
  });
}
