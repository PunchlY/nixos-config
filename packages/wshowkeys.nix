{prev}:
prev.wshowkeys.overrideAttrs (_: {
  pname = "wshowkeys-symbols";
  patches = [
    (builtins.toFile "symbols.patch" ''
      diff --git a/main.c b/main.c
      --- a/main.c
      +++ b/main.c
      @@ -14,6 +14,7 @@
       #include <unistd.h>
       #include <wayland-client.h>
       #include <xkbcommon/xkbcommon.h>
      +#include <xkbcommon/xkbcommon-keysyms.h>
       #include "devmgr.h"
       #include "shm.h"
       #include "pango.h"
      @@ -96,6 +97,47 @@
       	return CAIRO_SUBPIXEL_ORDER_DEFAULT;
       }

      +static const char *get_key_label(struct wsk_keypress *key) {
      +	switch (key->sym) {
      +		case XKB_KEY_Control_L:
      +		case XKB_KEY_Control_R: return "Ctrl";
      +		case XKB_KEY_Alt_L:
      +		case XKB_KEY_Alt_R: return "Alt";
      +		case XKB_KEY_Insert: return "Ins";
      +		case XKB_KEY_KP_Page_Up: return "󰘀";
      +		case XKB_KEY_KP_Page_Down: return "󰘁";
      +		case XKB_KEY_Return: return "󰌑";
      +		case XKB_KEY_Tab: return "󰌒";
      +		case XKB_KEY_BackSpace: return "󰁮";
      +		case XKB_KEY_space: return "󱁐";
      +		case XKB_KEY_Shift_L:
      +		case XKB_KEY_Shift_R: return "󰘶";
      +		case XKB_KEY_Super_L:
      +		case XKB_KEY_Super_R: return "󱄅";
      +		case XKB_KEY_Caps_Lock: return "󰌎";
      +		case XKB_KEY_Escape: return "󱊷";
      +		case XKB_KEY_Menu: return "󰮫";
      +		case XKB_KEY_Home: return "󰋜";
      +		case XKB_KEY_Up: return "󰁝";
      +		case XKB_KEY_Down: return "󰁅";
      +		case XKB_KEY_Left: return "󰁍";
      +		case XKB_KEY_Right: return "󰁔";
      +		case XKB_KEY_F1: return "󱊫";
      +		case XKB_KEY_F2: return "󱊬";
      +		case XKB_KEY_F3: return "󱊭";
      +		case XKB_KEY_F4: return "󱊮";
      +		case XKB_KEY_F5: return "󱊯";
      +		case XKB_KEY_F6: return "󱊰";
      +		case XKB_KEY_F7: return "󱊱";
      +		case XKB_KEY_F8: return "󱊲";
      +		case XKB_KEY_F9: return "󱊳";
      +		case XKB_KEY_F10: return "󱊴";
      +		case XKB_KEY_F11: return "󱊵";
      +		case XKB_KEY_F12: return "󱊶";
      +		default: return key->name;
      +	}
      +}
      +
       static void render_to_cairo(cairo_t *cairo, struct wsk_state *state,
       		int scale, uint32_t *width, uint32_t *height) {
       	cairo_set_operator(cairo, CAIRO_OPERATOR_SOURCE);
      @@ -109,7 +151,7 @@
       		if (!name[0]) {
       			special = true;
       			cairo_set_source_u32(cairo, state->specialfg);
      -			name = key->name;
      +			name = get_key_label(key);
       		} else {
       			cairo_set_source_u32(cairo, state->foreground);
       		}
      @@ -118,8 +160,8 @@

       		int w, h;
       		if (special) {
      -			get_text_size(cairo, state->font, &w, &h, NULL, scale, "%s+", name);
      -			pango_printf(cairo, state->font, scale,  "%s+", name);
      +			get_text_size(cairo, state->font, &w, &h, NULL, scale, "%s ", name);
      +			pango_printf(cairo, state->font, scale,  "%s ", name);
       		} else {
       			get_text_size(cairo, state->font, &w, &h, NULL, scale, "%s", name);
       			pango_printf(cairo, state->font, scale,  "%s", name);
    '')
  ];
})
