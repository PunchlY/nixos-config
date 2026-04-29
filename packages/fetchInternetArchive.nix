{
  fetchurl,
  linkFarm,
  lib,
}: {
  id,
  hash,
  formats ? null,
}: let
  metadata = lib.fromJSON (lib.readFile (fetchurl {
    url = "https://archive.org/metadata/${lib.escapeURL id}";
    inherit hash;
  }));
in
  linkFarm id (
    lib.map ({
      name,
      sha1,
      ...
    }: {
      name = name;
      path = fetchurl {
        url = "https://archive.org/download/${lib.escapeURL id}/${lib.escapeURL name}";
        sha1 = sha1;
      };
    })
    (lib.filter (data: data ? sha1 && (formats == null || lib.elem data.format formats)) metadata.files)
  )
