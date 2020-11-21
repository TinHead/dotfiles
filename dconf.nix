# Generated via dconf2nix: https://github.com/gvolpe/dconf2nix
{ lib, ... }:

let
  mkTuple = lib.hm.gvariant.mkTuple;
in
{
  dconf.settings = {
    "/" = {
      "app-picker-view" = "uint32 1";
      "command-history" = [ "tweaks" "terminal" "slack" "gnome-tewaks" "gnometweaks" "gnome-tweak" "gnometweak" "transmission" "transmission-remote-gtk" "gnome-tweaks" "syncthing-gtk" "syncthing-tray" "r" "syncthing-tray -api AYH3Pky2dqHvjuWK3zmtamqCPmdnb9Fy -target http://localhost:8384" ];
      "disabled-extensions" = [ "launch-new-instance@gnome-shell-extensions.gcampax.github.com" "TopIcons@phocean.net" "native-window-placement@gnome-shell-extensions.gcampax.github.com" "places-menu@gnome-shell-extensions.gcampax.github.com" "drive-menu@gnome-shell-extensions.gcampax.github.com" "screenshot-window-sizer@gnome-shell-extensions.gcampax.github.com" ];
      "enabled-extensions" = [ "dash-to-dock@micxgx.gmail.com" "user-theme@gnome-shell-extensions.gcampax.github.com" "appindicatorsupport@rgcjonas.gmail.com" "clipboard-indicator@tudmotu.com" ];
      "favorite-apps" = [ "org.gnome.Nautilus.desktop" "org.gnome.Terminal.desktop" "chrome-pkooggnaalmfkidjmlhoelhdllpphaga-Default.desktop" "chrome-hnpfjngllnobngcgfapefoaidbinmjnm-Default.desktop" "code.desktop" "google-chrome.desktop" "chrome-hpaefnmekalniabdkbahndoolpniokdp-Default.desktop" "bluejeans-v2.desktop" ];
      "had-bluetooth-devices-setup" = true;
    };

    "extensions/clipboard-indicator" = {
      "move-item-first" = true;
    };

    "extensions/dash-to-dock" = {
      "apply-custom-theme" = true;
      "custom-theme-shrink" = true;
      "extend-height" = false;
      "preferred-monitor" = 0;
      "running-indicator-style" = "SQUARES";
    };

    "extensions/dash-to-panel" = {
      "available-monitors" = [ 0 ];
      "dot-style-focused" = "DOTS";
      "dot-style-unfocused" = "DASHES";
      "hotkeys-overlay-combo" = "TEMPORARILY";
      "intellihide" = false;
      "isolate-monitors" = false;
      "multi-monitors" = false;
#      "panel-element-positions" = "'{"0":[{"element":"showAppsButton","visible":false,"position":"stackedTL"},{"element":"activitiesButton","visible":false,"position":"stackedTL"},{"element":"leftBox","visible":true,"position":"stackedTL"},{"element":"taskbar","visible":true,"position":"stackedTL"},{"element":"centerBox","visible":true,"position":"stackedBR"},{"element":"rightBox","visible":true,"position":"stackedBR"},{"element":"dateMenu","visible":true,"position":"stackedBR"},{"element":"systemMenu","visible":true,"position":"stackedBR"},{"element":"desktopButton","visible":true,"position":"stackedBR"}]}'";
#      "panel-positions" = "'{"0":"BOTTOM"}'";
      "primary-monitor" = 1;
      "show-appmenu" = false;
      "show-apps-icon-file" = "";
    };

    "extensions/user-theme" = {
      "name" = "Zuki-shell";
    };

    "weather" = {
      "automatic-location" = true;
      "locations" = "[<(uint32 2, <('Bucharest', 'LRBS', true, [(0.77667151713747673, 0.4561127053700873)], [(0.7755079584850495, 0.45553093477052004)])>)>]";
    };

    "world-clocks" = {
      "locations" = "[<(uint32 2, <('San Jose', 'KSJC', true, [(0.65204046995241238, -2.1279781519014169)], [(0.65169522637307531, -2.1274683063203246)])>)>, <(uint32 2, <('San Francisco', 'KOAK', true, [(0.65832848982162007, -2.133408063190589)], [(0.659296885757089, -2.1366218601153339)])>)>, <(uint32 2, <('New York', 'KNYC', true, [(0.71180344078725644, -1.2909618758762367)], [(0.71059804659265924, -1.2916478949920254)])>)>]";
    };

  };
}
