{ lib, pkgs, ... }: {

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = true;
      timeout = 0; # You can still press a key
    };
    # Early Systemd
    initrd.systemd.enable = true;
    #initrd.kernelModules = [ "i915" ];

    # Secure Boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
      autoGenerateKeys.enable = true;
      autoEnrollKeys = {
        enable = true;
        includeFirmwareBuiltinKeys = true;
        autoReboot = true;
      };
      #settings.consoleMode = "max";
    };

    # Fancy Animation :D
    plymouth =
      let
        theme = "rings"; # https://github.com/adi1090x/plymouth-themes
      in
      {
        enable = true;
        inherit theme;
        themePackages = [ (pkgs.adi1090x-plymouth-themes.override { selected_themes = [ theme ]; }) ];
      };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
  };

  security = {
    tpm2 = {
      enable = true;
      pkcs11.enable = true; # expose /run/current-system/sw/lib/libtpm2_pkcs11.so
      tctiEnvironment.enable = true; # TPM2TOOLS_TCTI and TPM2_PKCS11_TCTI env variables
    };
    pam.services = {
      hyprlock = {
      }; # PAM for Hyprlock
    };
  };
}
