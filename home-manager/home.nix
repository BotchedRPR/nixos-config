{ config, pkgs, lib, ... }:

let mod = "Mod4"; in {
  home.username = "igor";
  home.homeDirectory = "/home/igor";

  home.stateVersion = "26.05";

  xdg.enable = true;

  home.packages = with pkgs; [
    font-awesome
    nerd-fonts.symbols-only
    source-code-pro

    brightnessctl
    sway-contrib.grimshot

    wofi
  ];

  programs.home-manager.enable = true;

  programs.foot = {
    enable = true;

    settings = {
      main = {
        dpi-aware = "yes";
        font = "Liberation Mono:size=11";
        term = "xterm-256color";
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = mod;
      defaultWorkspace = "workspace number 0";

      keybindings = lib.attrsets.mergeAttrsList [
        (lib.attrsets.mergeAttrsList (map (num: let
          ws = toString num;
        in {
          "${mod}+${ws}" = "workspace ${ws}";
          "${mod}+Shift+${ws}" = "move container to workspace ${ws}";
        }) [1 2 3 4 5 6 7 8 9 0]))

        (lib.attrsets.concatMapAttrs (key: direction: {
            "${mod}+${key}" = "focus ${direction}";
            "${mod}+Ctrl+${key}" = "move ${direction}";
          }) {
            h = "left";
            j = "down";
            k = "up";
            l = "right";
          })

        {
          "${mod}+Return" = "exec --no-startup-id ${pkgs.foot}/bin/foot";
          "${mod}+d" = "exec --no-startup-id wofi --show drun,run";

          "${mod}+shift+q" = "kill";

          "${mod}+a" = "focus parent";
          "${mod}+e" = "layout toggle split";
          "${mod}+f" = "fullscreen toggle";
          "${mod}+g" = "split h";
          "${mod}+s" = "layout stacking";
          "${mod}+v" = "split v";
          "${mod}+w" = "layout tabbed";

          "${mod}+Shift+r" = "exec swaymsg reload";
          "--release Home" = "exec --no-startup-id ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
          "${mod}+Ctrl+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy";
          "${mod}+Ctrl+q" = "exit";

          # volume wheel
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "Shift+XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+";
          "Shift+XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
          "${mod}+XF86AudioRaiseVolume" = "exec brightnessctl set +5%";
          "${mod}+XF86AudioLowerVolume" = "exec brightnessctl set 5%-";
        }
      ];
      focus.followMouse = false;
      startup = [
        {command = "firefox";}
      ];
      workspaceAutoBackAndForth = true;
    };
    systemd.enable = true;
    wrapperFeatures = {gtk = true;};
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
  };
}
