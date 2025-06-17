{ 
  pkgs, 
  ... 
}:
{
  home.packages = [
    pkgs.hyprpaper
    pkgs.hypridle
  ];

  # Hyprpaper
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = "/home/bo/git/wallpapers/gruvbox-nix.png";
      wallpaper = "eDP-1, /home/bo/git/wallpapers/gruvbox-nix.png";
    };
  };

  # Hypridle
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";       # avoid starting multiple hyprlock instances.
        before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
        after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.

      };
      listener = [
        { 
          timeout = 120;                                            # 2min.
          on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
          on-resume = "brightnessctl -rd rgb:kbd_backlight";        # turn on keyboard backlight.
        }
        {
          timeout = 150;                                 # 2.5min.
          on-timeout = "brightnessctl -s set 10";        # set monitor backlight to minimum, avoid 0 on OLED monitor.
          on-resume = "brightnessctl -r";                # monitor backlight restore.
        }
        {
          timeout = 300;                                 # 5min
          on-timeout = "loginctl lock-session";          # lock screen when timeout has passed
        }
        {
          timeout = 330;                                 # 5.5min
          on-timeout = "hyprctl dispatch dpms off";      # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on";        # screen on when activity is detected after timeout has fired.
        }
        {
          timeout = 1800;                                # 30min
          on-timeout = "systemctl hibernate";            # suspend pc
        }
      ];
    };
  };

  # Hyprlock :D 
  
}
