{
  linkFarm,
  fetchurl,
}:
linkFarm "Brown Dust 2" [
  {
    name = "BD2StarterSetup.exe";
    path = fetchurl {
      url = "https://web.archive.org/web/20260531104225/https://pc.bd2.pmang.cloud/browndust2starter/starter/update/BD2StarterSetup.exe";
      hash = "sha256-rgPocObAKePWEY6UVYeTdPWsj2elazV30q1DhDcaNic=";
    };
  }
]
