{ 
  config, 
  pkgs,
  ... 
}: {

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.fastfetch = {
    enable = true;
  };
  
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
    plugins = [
      {name = "tide"; src = pkgs.fishPlugins.tide.src;}
      {name = "fzf"; src= pkgs.fishPlugins.fzf.src;}
    ];
  };

  programs.fd.enable = true;
  programs.bat.enable = true;
  programs.ripgrep.enable = true;

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
  };
}
