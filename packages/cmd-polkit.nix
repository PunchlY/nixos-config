{
  prev,
  fetchFromGitHub,
}:
prev.cmd-polkit.overrideAttrs (_oldAttrs: {
  version = "git";
  src = fetchFromGitHub {
    owner = "OmarCastro";
    repo = "cmd-polkit";
    rev = "d280aeb9d34f6dde39552b99a785d1f67e72edf3";
    hash = "sha256-ZAQwfUxgrpXCbMakndchjW0riAc+w2ox33FITwZ5BhY=";
  };
})
