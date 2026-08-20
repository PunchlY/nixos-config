{
  stdenv,
  fetchzip,
  nodejs,
  lib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cronstrue";
  version = "3.24.0";

  src = fetchzip {
    url = "https://registry.npmjs.org/cronstrue/-/cronstrue-${finalAttrs.version}.tgz";
    hash = "sha256-6g71Z6M17wjVcQER8YK0TCOJyLqHFDjJbC0vpMW0PVo=";
  };

  buildInputs = [
    nodejs
  ];

  preBuild = ''
    substituteInPlace bin/cli.js \
      --replace-fail \
        "require('../dist/cronstrue')" \
        "{toString:(e)=>require('$out/share/cronstrue/cronstrue-i18n.min.js').toString(e,{locale:values.lang})}" \
      --replace-fail \
        "const args = process.argv.slice(2);" \
        "const{values,positionals:args}=require('util').parseArgs({args:process.argv.slice(2),options:{lang:{type:'string',short:'l'}},allowPositionals:true});"
  '';

  installPhase = ''
    runHook preInstall
    install -Dm644 dist/cronstrue-i18n.min.js $out/share/cronstrue/cronstrue-i18n.min.js
    install -Dm755 bin/cli.js $out/bin/cronstrue
    runHook postInstall
  '';

  meta = {
    homepage = "https://www.npmjs.com/package/cronstrue";
    license = lib.licenses.mit;
  };
})
