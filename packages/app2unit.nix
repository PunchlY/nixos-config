{
  prev,
  fetchFromGitHub,
}:
prev.app2unit.overrideAttrs (oldAttrs: {
  version = "git";
  src = fetchFromGitHub {
    owner = "PunchlY";
    repo = "app2unit";
    rev = "5bba86c19aff326744559a9c6e007a529e3d776e";
    hash = "sha256-MQM/8P2pIEzuHiFOoqkJGCaeN1iWIWMYdS2c2fYKkj0=";
  };
})
