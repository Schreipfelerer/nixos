{ config, ... }:
{
  sops.secrets."backup/password" = {};
  services.restic.backups.varlib = {
    paths = [ "/var/lib" ];
    repository = "sftp:u472792@u472792.your-storagebox.de:/home/home_backup";
    passwordFile = config.sops.secrets."backup/password".path;

    extraOptions = [
      "sftp.command='ssh u472792@u472792.your-storagebox.de -i /etc/btrbk_key_hetzner -o StrictHostKeyChecking=no -s sftp'"
    ];

    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 4"
      "--keep-monthly 6"
    ];

    timerConfig.OnCalendar = "daily";
    timerConfig.Persistent = true;

    initialize = true;
    progressFps = 0.1;
    # This flag tells the flake to create the wrapper script in $PATH
    createWrapper = true;
  };
}
