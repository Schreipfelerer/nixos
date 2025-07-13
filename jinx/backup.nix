{ ... }:
{

  services.btrbk = {
    instances."remote_hetzner" = {
      onCalendar = "daily";
      settings = {
      	ssh_identity = "/etc/btrbk_key_hetzner";
	ssh_user = "u472792";

	timestamp_format = "long";
    	snapshot_preserve_min = "5d";
    	snapshot_preserve = "7d 4w 6m";
	incremental = "no";

	volume."/var/lib" = {
  	  subvolume = {
    	    "." = {
              snapshot_create = "always";
	    };
      	  };
	  target = "raw ssh://u472792.your-storagebox.de:23//home/home_backup";
    	};
      };
    };
  };
}
