{ pkgs, ... }:
let
  bt-toggle = pkgs.writeShellScript "bt-toggle" ''
    if ${pkgs.bluez}/bin/bluetoothctl show | ${pkgs.gnugrep}/bin/grep -q "Powered: yes"; then
      ${pkgs.bluez}/bin/bluetoothctl power off
    else
      ${pkgs.bluez}/bin/bluetoothctl power on
    fi
  '';
in
{
  programs.waybar = {
    enable = true;
    style = ./style.css;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";

        modules-left = [
          "niri/workspaces"
        ];

        modules-right = [
          "niri/language"
          "bluetooth"
          "wireplumber"
          "backlight"
          "network"
          "power-profiles-daemon"
          "battery"
          "clock"
          "tray"
        ];

        "niri/workspaces" = {
          disable-scroll = true;
          show-special = true;
          special-visible-only = true;
          all-outputs = false;

          persistent-workspaces = {
            "*" = 9;
          };
        };

        "niri/language" = {
          format-en = "🇺🇸";
          format-ru = "🇷🇺";
          min-length = 5;
          tooltip = false;
        };

        "bluetooth" = {
          format = "󰂯";                  # nf-md-bluetooth
          format-off = "󰂲";              # nf-md-bluetooth_off
          format-disabled = "󰂲";
          format-connected = "󰂱 {device_alias}";   # nf-md-bluetooth_connect
          format-connected-battery = "󰂱 {device_alias} {device_battery_percentage}%";

          tooltip-format = "{controller_alias}\t{controller_address}";
          tooltip-format-connected = "{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_battery_percentage}%";

          on-click = "blueman-manager";     # ЛКМ — подключение устройств
          on-click-right = "${bt-toggle}";  # ПКМ — вкл/выкл
        };

        "wireplumber" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% ";
          format-muted = "";
          format-icons = {
            "headphones" = "";
            "handsfree" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" ""];
          };
          on-click = "pavucontrol";
        };

        "backlight" = {
          format = "{icon} {percent}%";

          "format-icons" = [
            "󰃞"
            "󰃝"
            "󰃟"
            "󰃠"
          ];

          tooltip = false;
        };

        "network" = {
          interval = 5;

          "format-wifi" = "{icon} ({signalStrength}%)";
          "format-ethernet" = "{icon} Ethernet";
          "format-disconnected" = "󰤭 Disconnected";

          "format-icons" = {
            wifi = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];

            ethernet = [
              "󰈀"
            ];
          };

          tooltip = true;
          "tooltip-format-wifi" = "{essid}\nSignal: {signalStrength}%";
          "tooltip-format-ethernet" = "Ethernet\nInterface: {ifname}";
          "tooltip-format-disconnected" = "Disconnected";
        };

        "power-profiles-daemon" = {
          format = "{icon}";

          "format-icons" = {
            performance = "󰓅";
            balanced = "󰗑";
            "power-saver" = "󰌪";
          };

          tooltip = true;
          "tooltip-format" = "Режим: {profile}";
        };

        "battery" = {
          states = {
            warning = 30;
            critical = 1;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };

        "clock" = {
          format = "{:%d.%m.%Y - %H:%M}";
          format-alt = "{:%A, %B %d at %R}";
        };

        "tray" = {
          icon-size = 14;
          spacing = 1;
        };
      };
    };
  };
}
