{ pkgs, ... }:

{
  # ==================== TERMINAL ====================
  ghostty = {
    enable = true;             
    font-name = "MonoLisa";   
  };

  # ==================== EDITOR ====================
  helix = {
    enable = true;           
    editor = {
      disable-line-numbers = true;  
    };
    languages = {
      nix.enable = true;
      html.enable = true;
      css.enable = true;
      json.enable = true;
      rust.enable = true;
      go.enable = true;
      typescript.enable = true;
    };
  };

  # ==================== SHELL ====================
  zsh = {
    enable = true;             
    profileExtra = ''
      alias ls='eza --icons'
      alias tree='eza --tree --git-ignore --icons'
    '';
    sessionVariables = {
      DIRENV_LOG_FORMAT = "";
      GPG_TTY = "$(tty)";
      EDITOR = "hx";
    };
  };

  starship = {
    enable = true;              
  };

  # ==================== MULTIPLEXER ====================
  tmux = {
    enable = true;             
  };

  # ==================== CLI TOOLS ====================
  bat.enable = true;            
  direnv.enable = true;         
  fzf.enable = true;            
  gh.enable = true;             
  xplr.enable = true;           
  zoxide.enable = true;         

  # ==================== GIT ====================
  git = {
    enable = true;              
  };
}
