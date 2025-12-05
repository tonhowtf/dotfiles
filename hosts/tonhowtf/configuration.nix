{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ==================== BOOT ====================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ==================== NETWORKING ====================
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # ==================== LOCALE ====================
  time.timeZone = "America/Recife";
  
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  console.keyMap = "br-abnt2";

  # ==================== HYPRLAND ====================
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  services.xserver.enable = false;

  # ==================== AUDIO ====================
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # ==================== SECURITY ====================
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.polkit.enable = true;
  
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # ==================== PRINTING ====================
  services.printing.enable = true;

  # ==================== USERS ====================
  users.users.tonhowtf = {
    isNormalUser = true;
    description = "tonhowtf";
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "video"
      "audio"
    ];
    shell = pkgs.zsh;
  };

  # ==================== PROGRAMS ====================
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.git.enable = true;

  # ==================== FONTS ====================
  fonts.packages = with pkgs; [
    noto-fonts-cjk-sans
    noto-fonts
    noto-fonts-color-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    nerd-fonts.fira-code 
    nerd-fonts.jetbrains-mono
    nerd-fonts.iosevka
  ];

  # ==================== PACKAGES ====================
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Core
    vim
    git
    wget
    curl
    htop
    
    # Hyprland
    waybar
    wofi
    swww
    mako
    hyprpaper
    hyprlock
    hypridle
    
    # Audio & Brightness
    brightnessctl
    pavucontrol
    pamixer
    playerctl
    
    # Network
    networkmanagerapplet
    
    # Clipboard
    wl-clipboard
    cliphist
    
    # Screenshots
    grim
    slurp
    
    # File Manager
    xfce.thunar
    
    # Archive
    unzip
    zip
    p7zip
    
    # Polkit
    polkit_gnome
  ];

  # ==================== XDG PORTAL ====================
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
    ];
    config.common.default = "*";
  };

  # ==================== ENVIRONMENT ====================
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    EDITOR = "hx";
    VISUAL = "hx";
  };

  # ==================== GREETD ====================
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  # ==================== NIX SETTINGS ====================
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # ==================== SYSTEM ====================
  system.stateVersion = "25.11";
}
