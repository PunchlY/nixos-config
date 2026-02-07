{
  stdenv,
  fetchFromGitHub,
  nodejs,
  lib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unblockneteasemusic";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "UnblockNeteaseMusic";
    repo = "server";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-OqwsQ3kPlC/cjNOBXIiIV5rD3luHnJ4kLCqwTd2xhoA=";
  };

  buildInputs = [
    nodejs
  ];

  installPhase = ''
    install -Dm755 precompiled/app.js $out/bin/unblockneteasemusic
    install -Dm644 server.crt $out/server.crt
    install -Dm644 server.key $out/server.key
  '';

  meta = {
    description = "Revive unavailable songs for Netease Cloud Music";
    homepage = "https://github.com/UnblockNeteaseMusic/server";
    license = lib.licenses.lgpl3Only;
    mainProgram = "unblockneteasemusic";
  };
})
