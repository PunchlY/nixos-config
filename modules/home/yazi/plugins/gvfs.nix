{
  config,
  lib,
  pkgs,
  ...
}:

{
  # programs.yazi = {
  #   plugins = {
  #     gvfs = pkgs.fetchFromGitHub {
  #       owner = "boydaihungst";
  #       repo = "0.0.1";
  #       rev = "6db0c60";
  #       hash = "sha256-0W1nQ8MJ+BgPyKcn+oDzntX9BXplJEyl8UjsHWCHrE8=";
  #     };
  #   };
  #   initLua = ''
  #     require("gvfs"):setup({
  #       which_keys = "1234567890qwertyuiopasdfghjklzxcvbnm-=[]\\;',./!@#$%^&*()_+{}|:\"<>?",

  #     	blacklist_devices = { { name = "Wireless Device", scheme = "mtp" }, { scheme = "file" }, "Device Name"},

  #       save_path = os.getenv("HOME") .. "/.config/yazi/gvfs.private",

  #       save_path_automounts = os.getenv("HOME") .. "/.config/yazi/gvfs_automounts.private",

  #       input_position = { "center", y = 0, w = 60 },

  #       password_vault = "keyring",
  #     })
  #   '';
  #   settings.plugin.prepend_fetchers = [
  #     {
  #       id = "git";
  #       name = "*";
  #       run = "git";
  #     }
  #     {
  #       id = "git";
  #       name = "*/";
  #       run = "git";
  #     }
  #   ];
  # };
}
