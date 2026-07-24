{
  the-powder-toy,
  fetchFromGitHub,
}:
the-powder-toy.overrideAttrs {
  pname = "the-powder-toy-chinese";
  version = "99.5.396";

  src = fetchFromGitHub {
    owner = "Dragonrster";
    repo = "The-Powder-Toy-Chinese";
    rev = "201926fc815ca679a6b9df2f1870f7f7d4c60ad6";
    hash = "sha256-qFu+XKlIq3t2odBZDOeLjBB0Gb/1AIF3wVSKic9jlCA=";
  };
}
