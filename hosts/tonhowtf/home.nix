{ config, pkgs, ghostty-pkg, ... }:

{
  home.stateVersion = "24.11";
  home.username = "tonhowtf";
  home.homeDirectory = "/home/tonhowtf";
  programs.home-manager.enable = true;

  # ==================== User Packages ====================
  home.packages = with pkgs; [
    # ===== GAMES =====
	pkgs.godot_4
    # ===== TERMINAL =====
    ghostty-pkg  
    
    # ===== EDITOR =====
    helix       
    zed-editor
    # ===== SHELL =====
    starship 
    
    # ===== CLI TOOLS =====
    bat          # Cat melhorado
    eza          # ls melhorado
    fd           # Find melhorado
    ripgrep      # Grep melhorado
    fzf          # Fuzzy finder
    zoxide       # Smart cd
    jq           # JSON processor
    
    # ===== GIT TOOLS =====
    gh           # GitHub CLI
    delta        # Better git diff
    
    # ===== FILE MANAGER =====
    xplr         # File explorer TUI
    
    # ===== MULTIPLEXER =====
    tmux         # Terminal multiplexer
    
    # ===== DEVELOPMENT =====
    gcc
    gnumake
    nodejs_20
    
    # ===== BROWSER =====
    google-chrome
    
    # ===== UTILS =====
    neofetch
    btop
  ];

  # ==================== CONFIGURAÇÕES BÁSICAS ====================
  
  programs.git = {
  enable = true;
  settings = {
    user = {
      name = "tonhowtf";
      email = "tonhowtf@gmail.com"; 
    };
    init.defaultBranch = "main";
    core.editor = "hx";
  };
};

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # ==================== ALIASES ZSH ====================
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    
    shellAliases = {
      ls = "eza --icons";
      ll = "eza -lah --icons";
      tree = "eza --tree --git-ignore --icons";
      cat = "bat";
      grep = "rg";
      find = "fd";
      
      # Git
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";
      
      # NixOS
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      update = "sudo nix flake update /etc/nixos && rebuild";
      clean = "sudo nix-collect-garbage -d";
      
      # Hyprland
      hypr-reload = "hyprctl reload";
    };
    
    initContent = ''
      # Starship prompt
      eval "$(starship init zsh)"
      export EDITOR="hx"
      export VISUAL="hx"
      export DIRENV_LOG_FORMAT=""
      export GPG_TTY="$(tty)"
    '';
  };
}
