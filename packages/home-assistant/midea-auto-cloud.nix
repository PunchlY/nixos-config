{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lupa,
}:
buildHomeAssistantComponent (finalAttrs: {
  owner = "sususweet";
  domain = "midea_auto_cloud";
  version = "0.4.15";

  src = fetchFromGitHub {
    owner = finalAttrs.owner;
    repo = "midea_auto_cloud";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m6vFZlBwk32DFQtk/6W0PXwLtJGv91hvCEp4xGL6fjg=";
  };

  dependencies = [
    lupa
  ];

  meta = {
    description = "Control Midea devices via Cloud from Home Assistant";
    homepage = "https://github.com/sususweet/midea_auto_cloud";
    license = lib.licenses.asl20;
  };
})
