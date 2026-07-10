{
  fetchurl,
  stdenv,
  runCommandLocal,
  lib,
  love,
  lovely-injector,
  curl,
  p7zip,
  copyDesktopItems,
  makeWrapper,
  makeDesktopItem,
  requireFile,
  autoPatchelfHook,
  lua51Packages,
  withSteam ? true,
  withMods ? true,
}:
stdenv.mkDerivation (_finalAttrs: {
  pname = "balatro";
  version = "1.0.1o";

  src = runCommandLocal "balatro-source" {
    src = requireFile {
      name = "Balatro.exe";
      url = "https://store.steampowered.com/app/2379780/Balatro/";
      hash = "sha256-DXX+FkrM8zEnNNSzesmHiN0V8Ljk+buLf5DE5Z3pP0c=";
    };
    nativeBuildInputs = [
      p7zip
    ];
  } "7z x $src -o$out -y";

  steamAppId = 2379780;

  patches =
    [
      ./globals.patch
    ]
    ++ lib.optionals withSteam [
      ./steam.patch
    ];

  srcIcon = fetchurl {
    name = "balatro.png";
    url = "https://play-lh.googleusercontent.com/RSPv_SMlA3Lun8VHaJD7xCBQg29eCJR9sNJtZNJGlybVs8byYVLz4WnohrbLScC9srg";
    hash = "sha256-GoStvXBYI8x5b8T0wwH5D5C3Kahu0ssCyOM8MoLxy8Q=";
  };

  steamApi = fetchurl {
    url = "https://github.com/rlabrecque/SteamworksSDK/raw/009fa4e3c718b2a73f05d7f2f2a334e0019322ba/redistributable_bin/linux64/libsteam_api.so"; # v1.56
    hash = "sha256-Zxbj62j0pcqI+++m25Gwauja/Q73nbY0o9CmtuciR50=";
  };

  luasteam = fetchurl {
    url = "https://github.com/uspgamedev/luasteam/releases/download/v1.2.0/linux64_luasteam.so";
    hash = "sha256-tQ/T7lcqJGzapOIMqxG16baO/NJREdsDrV9871PkQY8=";
  };

  nativeBuildInputs = [
    p7zip
    copyDesktopItems
    makeWrapper
    autoPatchelfHook
  ];

  buildInputs =
    [
      love
    ]
    ++ lib.optionals withMods [
      lovely-injector
      curl
    ];

  desktopItems = [
    (makeDesktopItem {
      name = "balatro";
      desktopName = "Balatro";
      exec = "balatro";
      keywords = ["Game"];
      categories = ["Game"];
      icon = "balatro";
    })
  ];

  buildPhase = ''
    runHook preBuild

    loveFile=game.love
    7z a -tzip $loveFile ./*

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 $srcIcon $out/share/icons/hicolor/scalable/apps/balatro.png

    cat ${lib.getExe love} $loveFile > $out/share/Balatro
    chmod +x $out/share/Balatro

    ${lib.optionalString withSteam ''
      install -Dm755 $steamApi "$out/share/libsteam_api.so"
      install -Dm755 $luasteam "$out/share/luasteam.so"
      install -Dm755 ${lua51Packages.lua-https}/lib/lua/5.1/https.so "$out/share/https.so"

      echo -e "$steamAppId" > "$out/share/steam_appid.txt"
    ''}

    makeWrapper $out/share/Balatro $out/bin/balatro ${lib.optionalString withMods ''
      --prefix LD_PRELOAD : '${lovely-injector}/lib/liblovely.so' \
      --prefix LD_LIBRARY_PATH : '${lib.makeLibraryPath [curl]}' \
    ''} --set LUA_CPATH "$out/share/?.so;;"

    runHook postInstall
  '';

  meta = {
    description = "Poker roguelike";
    longDescription = ''
      Balatro is a hypnotically satisfying deckbuilder where you play illegal poker hands,
      discover game-changing jokers, and trigger adrenaline-pumping, outrageous combos.
    '';
    license = lib.licenses.unfree;
    homepage = "https://store.steampowered.com/app/2379780/Balatro/";
    platforms = ["x86_64-linux"];
    mainProgram = "balatro";
  };
})
