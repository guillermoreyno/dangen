{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

 # =========================================================================
  # CONFIGURACIÓN DEL ARRANQUE (BOOT) Y SOPORTE UNIVERSAL TPM2
  # =========================================================================

  # 1. Habilita el menú de arranque moderno (systemd-boot) en tu placa madre
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # 2. Levanta los motores de systemd en la fase pre-arranque (Initrd)
  # Esto es OBLIGATORIO para que el sistema pueda comunicarse con el chip TPM2
  boot.initrd.systemd.enable = true;

  # 3. Le ordena a systemd que intente desbloquear automáticamente cualquier
  # dispositivo cifrado (LUKS) usando el chip TPM2 si encuentra una llave válida
  security.tpm2.enable = true;

  # 4. Actualiza el núcleo del sistema a la versión de Linux estable más reciente
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # 5. Define la identidad de la máquina y activa la gestión de internet
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

  # Configuración declarativa con nix-flatpak
services.flatpak = {
    enable = true;
    update.auto.enable = true;

    # Evita que nix-flatpak borre o desconfigure los remotos/apps
    # que instalas manualmente fuera de Nix (como Threema Beta)
    uninstallUnmanaged = false;

    remotes = [
      {
        name = "flathub";
        location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
      }
    ];

    packages = [
      { appId = "org.onlyoffice.desktopeditors"; origin = "flathub"; }
      { appId = "org.keepassxc.KeePassXC"; origin = "flathub"; }
      { appId = "org.gnome.Calculator"; origin = "flathub"; }
      { appId = "io.github.kukuruzka165.materialgram"; origin = "flathub"; }
      { appId = "org.gnome.Showtime"; origin = "flathub"; }
      { appId = "net.nokyan.Resources"; origin = "flathub"; }
    ];
  };

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
