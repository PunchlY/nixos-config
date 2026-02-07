{ pkgs, filestash, ... }:
{
  imports = [ filestash.nixosModules.default ];

  services.filestash = {
    enable = false;
    settings = {
      general = {
        port = 8334;
        fork_button = false;
        display_hidden = true;
        filepage_default_view = "list";
        filepage_default_sort = "name";
      };
      auth.admin_file = pkgs.writeText "secret" "filestash";
      connections = [
      ];
    };
  };
}
