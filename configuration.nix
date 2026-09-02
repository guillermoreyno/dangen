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
    "luks-60c879d1-901a-40f0-8b37-602e0bebcb43" = {
      device = "/dev/disk/by-uuid/60c879d1-901a-40f0-8b37-602e0bebcb43";
      crypttabExtraOpts = [ "tpm2-device=auto" ];
    };
    "luks-289e3cd7-c9cb-454f-8ca8-b74bc13ffd15" = {
      device = "/dev/disk/by-uuid/289e3cd7-c9cb-454f-8ca8-b74bc13ffd15";
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

  # Habilitar el motor nativo de Flatpak
  services.flatpak.enable = true;

  # Automatización nativa para Flathub y tus Flatpaks (Bazaar + Futuros programas)
  systemd.services.flatpak-managed-apps = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      # 1. Registrar Flathub de forma correcta
      flatpak remote-add --if-not-exists flathub https://flathub.org

      # 2. LISTA DE FLATPAKS (Agrega aquí tus programas separados por un espacio)
      flatpak install flathub -y \
        org.onlyoffice.desktopeditors \
	org.keepassxc.KeePassXC \
	io.github.kukuruzka165.materialgram    
    '';
  };
  # Eliminar aplicaciones preinstaladas de GNOME (Adiós Tienda de Software)
  environment.gnome.excludePackages = with pkgs; [
    gnome-software # Esta línea borra la tienda de GNOME por completo
  ];

}
