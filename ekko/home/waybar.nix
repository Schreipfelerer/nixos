{
  config,
  pkgs,
  ...
}:

let workspacesDefault = {
  move-to-monitor = true;
  #window-rewrite = {
      #"class<firefox>" =  "󰈹 ";
      #"class<steam>" =  "󰓓 ";
      #"class<thunderbird>" =  " ";
      #"class<discord>" = " ";
      #};
  #window-rewrite-default = "?";
  format = "{icon}";
  format-icons = {
    empty = "_";
  };
};
in 
{
  # Depedencies
  home.packages = [];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.mainbar = {
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [ "cpu" "memory" "idle_inhibitor" "power-profiles-daemon" "privacy"];
      modules-center = [ "hyprland/workspaces" "clock" "hyprland/workspaces#work2"];
      modules-right = [ "wireplumber" "backlight" "battery" "network" "bluetooth" "custom/power"];  
      idle_inhibitor =  {
        format = "[ {icon} ]";
        format-icons = {
            activated = " ";
            deactivated = " ";
        };
      }; 
      cpu = {
        format = "[ {usage}%   ]";
        interval = 1;
      };
      memory = {
        format = "[ {percentage}%   ]";
        tooltip-format = "{swapUsed:0.1f} GiB Swap";
        interval = 1;
      };
      power-profiles-daemon = {
        format ="[ {icon} ]";
        tooltip-format = "Power profile: {profile}\nDriver: {driver}";
        tooltip = true;
        format-icons = {
          default = " ";
          performance = " ";
          balanced = " ";
          power-saver = " ";
        };
      };


      clock = {
        format = "{:%H:%M}";
      };
      "hyprland/workspaces" = {
        persistent-workspaces = {
          "*" = [ 1 2 3 4 5 ];
        };
        ignore-workspaces = [ "[6789]" "10" ];
      } // workspacesDefault;
      "hyprland/workspaces#work2" = {
        persistent-workspaces = {
          "*" = [ 6 7 8 9 10 ];
        };
        ignore-workspaces = [ "[12345]" ];
      } // workspacesDefault;

      
      wireplumber = {
        format = "[ {volume}% {icon} ]";
        format-muted = "[ {volume}%   ]";
        format-icons = {
            headphone = " ";
            hands-free = " ";
            headset = " ";
            phone = " ";
            portable = " ";
            car = " ";
            default = ["" " " " "];
        };
        on-click = "pavucontrol";
      };
      backlight = {
    	  device = "intel_backlight";
    	  format = "[ {percent}% {icon} ]";
    	  format-icons = [" "];
      };
      battery = {
        interval = 1;
        format = "[ {capacity}% {icon} ]";
        states = {
        	warning = 30;
        	critical = 15;
    	  };
	      format-icons = [" " " " " " " " " "];
        format-charging = "[ {capacity}%  ]";
        tooltip-format =  "{timeTo} with {power:0.1f} W";
      };
      network = {
        interval = 1;
        format-wifi = "[ {icon} ]";
        format-ethernet = "[ 󰌘  ]";
        format-disconnected = "[ 󰌙  ]";
        format-linked = "[ 󰌚  ]";
        format-icons = [ "󰤟 " "󰤢 " "󰤥 " "󰤨 "];

        tooltip-format-wifi = "{essid} ({signalStrength}%) {ipaddr}  ";
        tooltip-format-ethernet = "{ipaddr} 󰈀 ";
        tooltip-format-disconnected = "Disconnected";
      };
      bluetooth = {
        format = "";
        format-off = "[ 󰂲 ]";
        format-on = "[  ]";
        format-connected = "[ 󰂱 ]";
        format-no-controller = "";
      };
      "custom/power" = {
		    format = "[  ]";
		    on-click = "wlogout";
	    };
    };
  };
}
