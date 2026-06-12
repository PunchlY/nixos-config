{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:
buildHomeAssistantComponent (finalAttrs: {
  owner = "banto6";
  domain = "haier";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = finalAttrs.owner;
    repo = "haier";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = false;
    sha256 = "sha256-92tla8+fvvym6cpz1ZQCjZZwx769diAN7GUzRM6DwGs=";
  };

  meta = {
    description = "Haier HomeAssistant integration";
    homepage = "https://github.com/banto6/haier";
    license = lib.licenses.asl20;
  };
})
