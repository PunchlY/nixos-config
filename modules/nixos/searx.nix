{ config, lib, ... }:
let
  cfg = config.services.searx;
in
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
          ''(.*\.)?gitee\.(com|net)$''
          ''(.*\.)?gitcode\.(com|net|host)$''
          ''(.*\.)?sohu\.com$''
          ''(.*\.)?sina\.cn$''
          ''(.*\.)?163\.com$''
          ''(.*\.)?doubao\.com$''
          ''(.*\.)?toutiao\.com$''
          ''(.*\.)?news?\.qq\.com$''
          ''(.*\.)?cloud\.tencent\.(com|cn)$''
          ''(.*\.)?taobao\.com$''
          ''(.*\.)?1688\.com$''
          ''(.*\.)?jd\.(com|hk)$''
        ];
        hostnames.high_priority = [
          ''^wiki\.nixos\.org$''
          ''^github\.com$''
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

    programs.chromium = lib.mkIf config.programs.chromium.enable {
      extraOpts = {
        DefaultSearchProviderEnabled = true;
        DefaultSearchProviderImageURL = "http://${cfg.domain}/static/themes/simple/img/favicon.svg";
        DefaultSearchProviderKeyword = cfg.domain;
        DefaultSearchProviderName = "Searx";
        DefaultSearchProviderSearchURL = "http://${cfg.domain}/search?q={searchTerms}";
        DefaultSearchProviderSuggestURL = "http://${cfg.domain}/autocompleter?q={searchTerms}";
      };
    };
  };
}
