{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:
buildHomeAssistantComponent (finalAttrs: {
  owner = "banto6";
  domain = "haier";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = finalAttrs.owner;
    repo = "haier";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ZVz2Tfkrhq1xpYU4D749wTTePvqOEWmyNse3evDBUgk=";
  };

  meta = {
    description = "Haier HomeAssistant integration";
    homepage = "https://github.com/banto6/haier";
    license = lib.licenses.asl20;
  };
})
