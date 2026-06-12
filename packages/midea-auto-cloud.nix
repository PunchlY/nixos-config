{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  home-assistant,
}:
buildHomeAssistantComponent (finalAttrs: {
  owner = "sususweet";
  domain = "midea_auto_cloud";
  version = "0.3.4-pre1";

  src = fetchFromGitHub {
    owner = finalAttrs.owner;
    repo = "midea_auto_cloud";
    rev = "v${finalAttrs.version}";
    hash = "sha256-7Lp7XpVTfNQczQLC10R2b0NWUIM2/g2yXCu2Rd9vdJg=";
  };

  dependencies = [
    home-assistant.python3Packages.lupa
  ];

  meta = {
    description = "Control Midea devices via Cloud from Home Assistant";
    homepage = "https://github.com/sususweet/midea_auto_cloud";
    license = lib.licenses.asl20;
  };
})
