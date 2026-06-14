{
  stdenv,
  fetchFromGitLab,
}:
stdenv.mkDerivation rec {
  pname = "ls-wayland";
  version = "1.0.0-0.4";

  src = fetchFromGitLab {
    owner = "robustus";
    repo = "ls-wayland";
    rev = "e0dc57bdf17d742a50213c3e638ee102d5d4a224";
    hash = "sha256-fUSP5j8yjo3nLhaIp/io+iZaWHbMfsDROJAsxOznJa4=";
  };

  installPhase = ''
    runHook preInstall
    install -Dm755 ls-wayland $out/bin/ls-wayland
    runHook postInstall
  '';

  meta = {
    description = "List the globals of Wayland";
    homepage = "https://gitlab.com/robustus/ls-wayland";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "ls-wayland";
  };
}
