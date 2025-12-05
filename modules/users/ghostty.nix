{ config, lib, pkgs, ghostty-pkg, ghostty-themes, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.ghostty;
in {
  options.ghostty = {
    enable = mkEnableOption "Ghostty terminal";
    
    font-name = mkOption {
      type = types.str;
      default = "MonoLisa";
      description = "Font to use in Ghostty";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ ghostty-pkg ];
    home.file.".config/ghostty/config".text = ''
      # Ghostty Configuration - Igual Zoey
      
      # Font Configuration
      font-family = "${cfg.font-name}"
      font-size = 17
      
      # Font Features (MonoLisa)
      font-feature = ss01,ss04,ss07,ss08,ss10,ss11,ss13,ss14,ss15,ss16,ss17,ss18
      
      # Cursor
      cursor-style = bar
      cursor-style-blink = true
      
      # Window
      background-opacity = 1
      window-padding-x = 10
      window-padding-y = 8
      
      # Theme
      theme = dark:nyxvamp-veil
      
      # Shell Integration
      shell-integration = detect
      shell-integration-features = cursor,sudo,title
      
      # Clipboard
      clipboard-read = allow
      clipboard-write = allow
      clipboard-paste-protection = true
      
      # Scrollback
      scrollback-limit = 50000
      
      # Mouse
      mouse-hide-while-typing = true
      
      # Keybindings (adaptado para Linux)
      keybind = ctrl+shift+t=new_tab
      keybind = ctrl+shift+w=close_tab
      keybind = ctrl+shift+c=copy_to_clipboard
      keybind = ctrl+shift+v=paste_from_clipboard
      keybind = ctrl+shift+equal=increase_font_size:1
      keybind = ctrl+shift+minus=decrease_font_size:1
      keybind = ctrl+shift+0=reset_font_size
    '';
    home.file.".config/ghostty/themes" = {
      source = ghostty-themes;
      recursive = true;
    };
  };
}
