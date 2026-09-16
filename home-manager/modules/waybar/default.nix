{ ... }: {
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
