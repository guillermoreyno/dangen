{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Cargador de arranque
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Habilitar systemd en el arranque (Requerido para TPM2)
  boot.initrd.systemd.enable = true;

# Configuración declarativa de discos cifrados con soporte TPM2
  boot.initrd.luks.devices = {
    "luks-d0707379-a68e-4599-97d0-3abd720c9f30" = {
      device = "/dev/disk/by-uuid/d0707379-a68e-4599-97d0-3abd720c9f30";
      crypttabExtraOpts = [ "tpm2-device=auto" ];
    };
    "luks-59ce3ec8-93d8-49e2-8d8f-ca31dff4cd1a" = {
      device = "/dev/disk/by-uuid/59ce3ec8-93d8-49e2-8d8f-ca31dff4cd1a";
      crypttabExtraOpts = [ "tpm2-device=auto" ];
    };
  };

  # Kernel más reciente
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Red e Identidad
  networking.hostName = "dangen";
  networking.networkmanager.enable = true;

  # Región, Hora e Idioma
  time.timeZone = "America/Santiago";
  i18n.defaultLocale = "es_AR.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CL.UTF-8";
    LC_IDENTIFICATION = "es_CL.UTF-8";
    LC_MEASUREMENT = "es_CL.UTF-8";
    LC_MONETARY = "es_CL.UTF-8";
    LC_NAME = "es_CL.UTF-8";
    LC_NUMERIC = "es_CL.UTF-8";
    LC_PAPER = "es_CL.UTF-8";
    LC_TELEPHONE = "es_CL.UTF-8";
    LC_TIME = "es_CL.UTF-8";
  };

  # Entorno Gráfico (GNOME)
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Teclado en X11 y Consola
  services.xserver.xkb = {
    layout = "latam";
    variant = "";
  };
  console.keyMap = "la-latin1";

  # Impresión y Audio (Pipewire)
  services.printing.enable = true;
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Configuración de tu Usuario Principal
  users.users."lab1" = {
    isNormalUser = true;
    description = "Encargado Laboratorio";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ ];
    hashedPasswordFile = "/etc/nixos/secrets/password-hash";

  };

  # Programas del Sistema y Licencias
  programs.firefox.enable = true;
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    pkgs.proton-vpn
  ];
  # Habilitar zram para optimización de memoria swap en RAM
  zramSwap.enable = true;


  # Opciones Avanzadas de Nix y Flakes
  nix.settings.warn-dirty = false;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Estado de compatibilidad del sistema
  system.stateVersion = "26.05";

  # Habilitar soporte Flatpak nativo
  services.flatpak.enable = true;

  # Formato correcto sin prefijos "flathub:" para nix-flatpak en NixOS
  services.flatpak.packages = [
    "org.onlyoffice.desktopeditors"
    "org.keepassxc.KeePassXC"
    "org.gnome.Calculator"
    "io.github.kukuruzka165.materialgram"
    "org.gnome.Showtime"
  ];
  # Eliminar aplicaciones preinstaladas de GNOME (Lista Corregida)
  environment.gnome.excludePackages = with pkgs; [
    gnome-software         # Tienda de Software
    gnome-console          # Consola vieja (Mantenemos tu terminal Ptyxis)
    gnome-contacts         # Contactos
    gnome-weather          # Meteorología
    gnome-clocks           # Relojes
    gnome-maps             # Mapas
    simple-scan            # Escáner de documentos
    snapshot               # Cámara
    gnome-calculator       # Calculadora
    gnome-characters       # Caracteres
    gnome-tour             # Tour de GNOME
    yelp                   # Ayuda
    epiphany               # Web
    gnome-calendar         # Calendario
    gnome-text-editor      # Editor de textos stock
    gnome-connections      # Conexiones
    gnome-system-monitor   # Monitor del sistema
    baobab                 # Analizador de uso de disco
    gnome-disk-utility     # Discos
    
    # 🚫 ELIMINAR EL NUEVO REPRODUCTOR DE VÍDEO Y LA IMPRESIÓN
    totem                  # Filtro base de vídeos antiguo
    showtime               # El NUEVO Reproductor de vídeo real de GNOME
    system-config-printer  # Administrar impresión
    
    # NOTA: Dejamos fuera a 'decibels' y 'gnome-music' para que tu reproductor de SONIDO se quede.
  ];
}
