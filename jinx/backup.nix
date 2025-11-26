{ ... }:
{
  services.restic.backups.varlib = {
    paths = [ "/var/lib" ];
    repository = "sftp:u472792@u472792.your-storagebox.de:/home/home_backup";

    extraOptions = [
      "sftp.command='ssh -i /etc/btrbk_key_hetzner -o StrictHostKeyChecking=no -s sftp'"
    ];

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];

    timerConfig.OnCalendar = "daily";
    timerConfig.Persistent = true;

    # This flag tells the flake to create the wrapper script in $PATH
    createWrapper = true;
  };
}
