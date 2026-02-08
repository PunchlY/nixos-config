final: prev:
prev.fuzzel.overrideAttrs (oldAttrs: {
  version = "1.14.0";
  src = final.fetchFromGitea {
    domain = "codeberg.org";
    owner = "dnkl";
    repo = "fuzzel";
    rev = "1.14.0";
    sha256 = "sha256-9O6CABh149ZtNu3sEhuycsM7pinVrBzU+rLxCAbxobs=";
  };
})
