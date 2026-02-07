{ config, lib, ... }:

{
  config = lib.mkIf config.services.searx.enable {
    services.searx = {
      domain = "searx.local";
      configureNginx = true;
      settings = {
        server = {
          port = 8080;
          secret_key =
            toString (lib.trivial.oldestSupportedRelease / 3.0)
            + toString (lib.trivial.oldestSupportedRelease / 0.3)
            + lib.version;
          method = "GET";
          image_proxy = false;
        };

        ui = {
          query_in_title = true;
          center_alignment = true;
          results_on_new_tab = true;
          # cache_url = "https://archive.today/";
        };

        plugins."searx.plugins.calculator.SXNGPlugin".active = true;
        plugins."searx.plugins.hash_plugin.SXNGPlugin".active = true;
        plugins."searx.plugins.time_zone.SXNGPlugin".active = true;
        plugins."searx.plugins.hostnames.SXNGPlugin".active = true;
        plugins."searx.plugins.unit_converter.SXNGPlugin".active = true;
        plugins."searx.plugins.tracker_url_remover.SXNGPlugin".active = true;
        plugins."searx.plugins.oa_doi_rewrite.SXNGPlugin".active = true;
        plugins."searx.plugins.ahmia_filter.SXNGPlugin".active = true;

        hostnames.remove = [
          ''(.*\.)?csdn\.net$''
          ''(.*\.)?nixos\.wiki$''
        ];
        hostnames.high_priority = [
          ''^wiki\.nixos\.org$''
        ];

        search = {
          autocomplete = "duckduckgo";
          favicon_resolver = "duckduckgo";
        };

        engines = [
          {
            name = "nixos wiki";
            disabled = false;
          }
          {
            name = "codeberg";
            disabled = false;
          }
        ];
      };
    };

    networking.hosts."127.0.0.1" = [ config.services.searx.domain ];
  };
}
