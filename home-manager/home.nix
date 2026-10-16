{ config, pkgs, lib, ... }:

let mod = "Mod4"; in {
  home.username = "igor";
  home.homeDirectory = "/home/igor";

  home.stateVersion = "26.05";

  programs.home-manager.enable = true;

  xdg.enable = true;

  # Android Studio
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;

  home.packages = with pkgs; [
    font-awesome
    nerd-fonts.symbols-only
    source-code-pro

    brightnessctl
    sway-contrib.grimshot

    wofi
    ghidra-bin
    pavucontrol

    gh
    android-studio

    gimp
  ];

  home.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

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

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  wayland.windowManager.sway = {
    enable = true;
    config = {
      modifier = mod;
      defaultWorkspace = "workspace number 0";
      bars = [];

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
          "${mod}+Shift+Space" = "floating toggle";

          "${mod}+Shift+r" = "exec swaymsg reload";
          "--release Home" = "exec --no-startup-id ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
          "${mod}+Ctrl+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy";
          "${mod}+Ctrl+q" = "exit";

          # volume wheel [Ext. keyboard]
          "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "Shift+XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+";
          "Shift+XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
          "${mod}+XF86AudioRaiseVolume" = "exec brightnessctl set +5%";
          "${mod}+XF86AudioLowerVolume" = "exec brightnessctl set 5%-";

          # Same functionality but w/ laptop keyboard [TODO split to renoir profile]
          # TODO: Why the fuck is fn key xf86wakeup
          "XF86AudioMute" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 0%";
          "XF86Wakeup+F2" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
          "XF86Wakeup+F3" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
          "Shift+XF86Wakeup+F2" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%-";
          "Shift+XF86Wakeup+F3" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 5%+";
          "XF86AudioMicMute" = "exec wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0%";
          "XF86MonBrightnessDown" = "exec brightnessctl set 5%-";
          "XF86MonBrightnessUp" = "exec brightnessctl set +5%";
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

  # Enable zsh
  programs.zsh = {
    enable = true;

    # Enable Oh-my-zsh
    oh-my-zsh = {
      enable = true;

      plugins = [ "git" "sudo" "docker" "kubectl" ];
      theme = "crunch";
    };
  };
}
