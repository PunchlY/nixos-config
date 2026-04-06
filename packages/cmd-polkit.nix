{
  prev,
  fetchFromGitHub,
}:
prev.cmd-polkit.overrideAttrs (_oldAttrs: {
  version = "git";
  src = fetchFromGitHub {
    owner = "OmarCastro";
    repo = "cmd-polkit";
    rev = "0b52f76";
    sha256 = "sha256-vECq18kRlWvg/OMpa2H+vFqYRpCmeOAGI56DBWYF0lA=";
  };
})
