{ config, lib, pkgs, helix-themes, ... }:

let
  inherit (lib) mkEnableOption mkIf mkOption types;
  cfg = config.helix;
in {
  options.helix = {
    enable = mkEnableOption "Helix editor";
    
    editor = {
      disable-line-numbers = mkOption {
        type = types.bool;
        default = true;
        description = "Disable line numbers in gutter";
      };
    };
    
    languages = {
      nix.enable = mkEnableOption "Nix language support";
      html.enable = mkEnableOption "HTML language support";
      css.enable = mkEnableOption "CSS language support";
      json.enable = mkEnableOption "JSON language support";
      rust.enable = mkEnableOption "Rust language support";
      go.enable = mkEnableOption "Go language support";
      typescript.enable = mkEnableOption "TypeScript language support";
    };
  };
  config = mkIf cfg.enable {
    home.packages = [ pkgs.helix ];
    home.file.".config/helix/config.toml".text = ''
      theme = "nyxvamp-veil"
      [editor]
      scrolloff = 99          
      line-number = "relative"
      cursorline = true
      color-modes = true
      true-color = true
      auto-save = true
      
      ${if cfg.editor.disable-line-numbers then ''
      gutters = ["diagnostics", "spacer", "diff"]
      '' else ''
      gutters = ["diagnostics", "spacer", "diff", "line-numbers"]
      ''}
      
      [editor.cursor-shape]
      insert = "bar"
      normal = "block"
      select = "underline"
      
      [editor.soft-wrap]
      enable = true
      wrap-at-text-width = true
      
      [editor.lsp]
      enable = true
      display-messages = false
      display-inlay-hints = true
      
      [editor.inline-diagnostics]
      cursor-line = "warning"
      other-lines = "warning"
      
      [editor.statusline]
      separator = "|"
      left = ["mode", "file-name", "file-modification-indicator"]
      center = []
      right = ["diagnostics", "version-control", "register", "position"]
      
      [editor.whitespace]
      render = "none"
      
      [keys.normal]
      esc = ["collapse_selection", "keep_primary_selection"]
    '';

    home.file.".config/helix/themes" = {
      source = helix-themes;
      recursive = true;
    };
    
    home.file.".config/helix/languages.toml".text = ''
      
      ${lib.optionalString cfg.languages.nix.enable ''
      [[language]]
      name = "nix"
      auto-format = true
      formatter = { command = "alejandra" }
      ''}
      
      ${lib.optionalString cfg.languages.rust.enable ''
      [[language]]
      name = "rust"
      auto-format = true
      ''}
      
      ${lib.optionalString cfg.languages.go.enable ''
      [[language]]
      name = "go"
      auto-format = true
      ''}
      
      ${lib.optionalString cfg.languages.typescript.enable ''
      [[language]]
      name = "typescript"
      auto-format = true
      formatter = { command = "prettier", args = ["--parser", "typescript"] }
      
      [[language]]
      name = "javascript"
      auto-format = true
      formatter = { command = "prettier", args = ["--parser", "javascript"] }
      ''}
      
      ${lib.optionalString cfg.languages.json.enable ''
      [[language]]
      name = "json"
      auto-format = true
      ''}
      
      ${lib.optionalString cfg.languages.html.enable ''
      [[language]]
      name = "html"
      auto-format = true
      ''}
      
      ${lib.optionalString cfg.languages.css.enable ''
      [[language]]
      name = "css"
      auto-format = true
      ''}
    '';
  };
}
