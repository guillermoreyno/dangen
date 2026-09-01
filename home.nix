{ pkgs, ... }:

{
  # Tus aplicaciones personales (Manteniendo tus herramientas y añadidos nuevos)
  home.packages = [
    pkgs.git                        # Herramienta de control de versiones
    pkgs.brave-origin               # Versión de Brave limpia (sin Bloatware/AI/Wallet)
    pkgs.keepassxc                  # Gestor de contraseñas local y seguro
    pkgs.onlyoffice-desktopeditors   # Suite ofimática compatible con Office
    pkgs.proton-authenticator       # Generador de códigos 2FA de Proton
    pkgs.materialgram               # Cliente alternativo de Telegram
    pkgs.ptyxis                     # Tu terminal predeterminada

    # Extensiones de GNOME y herramientas de gestión
    pkgs.gnome-extensions-cli       # Permite administrar extensiones por terminal
    pkgs.gnomeExtensions.dash-to-dock # Transforma el panel en un Dock estilo macOS
    pkgs.gnomeExtensions.caffeine   # Evita que la pantalla se apague o suspenda
    pkgs.gnomeExtensions.tiling-shell # Añade un potente gestor de ventanas en mosaico (Tiling)
    pkgs.gnomeExtensions.appindicator # Obligatoria para ver el ícono de Proton VPN
    
    # Herramientas del Sistema y Terminal agregadas
    pkgs.fastfetch                  # Información del sistema
    pkgs.cava                       # Visualizador de audio para la terminal
    pkgs.curl                       # Transferencia de datos por red
    pkgs.weathr                     # Aplicación de clima CLI en Rust
    pkgs.asciiquarium               # Acuario de animación ASCII en la terminal
  ];

  # Configuración del entorno y terminal predeterminada
  xdg.terminal-exec = {
    enable = true;
    settings.default = [ "org.gnome.Ptyxis.desktop" ];
  };

  home.sessionVariables = {
    TERMINAL = "ptyxis";
  };

  # Configuración declarativa moderna de Git
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "WillyDoc";
        email = "guillermoreyno@institutoclaret.cl";
      };
    };
  };

  # Habilita la gestión de Home Manager
  programs.home-manager.enable = true;

  # Configuración de Bash, tus alias y auto-ejecución de Fastfetch
  programs.bash = {
    enable = true;
    shellAliases = {
      up = "nix flake update --flake path:/home/lab1/nixos-config && sudo nixos-rebuild switch --flake path:/home/lab1/nixos-config#dangen";
      clima = "curl 'wttr.in/Temuco,Chile?m' && curl 'wttr.in/-38.6623998,-72.6373735'";
      f = "fastfetch";
      acuario = "asciiquarium";
    };
    initExtra = ''
      # Ejecuta tu diseño personalizado de Fastfetch
      fastfetch

      # Mensaje recordatorio de Git para tu repositorio dangen
      echo -e "\n\e[1;34m💡 Recordatorio de Git (Respaldar configuraciones):\e[0m"
      echo -e "   git add ."
      echo -e "   git commit -m \"un mensaje corto de lo que cambiaste\""
      echo -e "   git push\n"
    '';
  };

  # 🚀 AUTOMATIZACIÓN DE INICIO DE APLICACIONES 🚀
  xdg.configFile."autostart/brave.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Brave Origin
    Exec=brave-origin
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
  '';

  xdg.configFile."autostart/protonvpn.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Proton VPN
    Exec=protonvpn-app
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
  '';

  xdg.configFile."autostart/materialgram.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Materialgram
    Exec=materialgram
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
  '';

  # ⚙️ CONFIGURACIÓN DECLARATIVA DE FASTFETCH ⚙️
  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com",
      "logo": { "padding": { "top": 1, "left": 2 } },
      "display": { "separator": "  \u001b[38;5;250m➡️  \u001b[0m" },
      "modules": [
        "title",
        { "type": "custom", "format": "\u001b[32m╠══ S I S T E M A ══╣═════════════════════════════════════════\u001b[0m" },
        { "type": "os", "key": "  🐧  \u001b[33mOS\u001b[0m     ", "format": "{3}" },
        { "type": "kernel",   "key": "  🎛   \u001b[33mKern\u001b[0m   " },
        { "type": "uptime",   "key": "  ⏱️   \u001b[33mUp\u001b[0m     " },
        { "type": "packages", "key": "  📦  \u001b[33mPkgs\u001b[0m   ", "flatpak": true, "snap": true },
        { "type": "shell",    "key": "  🐚  \u001b[33mSh\u001b[0m     " },
        { "type": "custom", "format": "\u001b[38;5;208m╠══ E N T O R N O ══╣═════════════════════════════════════════\u001b[0m" },
        { "type": "de",       "key": "  🖥   \u001b[33mDE\u001b[0m     " },
        { "type": "wm",       "key": "  🪟  \u001b[33mWM\u001b[0m     " },
        { "type": "theme",    "key": "  🎨  \u001b[33mTema\u001b[0m   " },
        { "type": "icons",    "key": "  🖼   \u001b[33mIcon\u001b[0m   " },
        { "type": "terminal", "key": "  📟  \u001b[33mTerm\u001b[0m   " },
        { "type": "custom", "format": "\u001b[37m╠══ H A R D W A R E ══╣═══════════════════════════════════════\u001b[0m" },
        { "type": "host",     "key": "  💻  \u001b[33mHost\u001b[0m   " },
        { "type": "cpu", "key": "  🧠  \u001b[33mCPU\u001b[0m    ", "showPeCoreCount": false, "temp": false },
        { "type": "gpu", "key": "  🎮  \u001b[33mGPU\u001b[0m    ", "format": "{1} {2}", "hideType": "integrated" },
        { "type": "memory",   "key": "  📟  \u001b[33mRAM\u001b[0m    " },
        { "type": "disk",     "key": "  💽  \u001b[33mDisk\u001b[0m   " },
        { "type": "custom", "format": "\u001b[38;5;242m════════════════════════════════════════════════════════════\u001b[0m" },
        "colors"
      ]
    }
  '';

  # 📊 CONFIGURACIÓN DECLARATIVA DE CAVA 📊
  xdg.configFile."cava/config".text = ''
    [general]
    bars = 0
    bar_width = 1
    bar_spacing = 1

    [output]
    method = ncurses

    [color]
    gradient = 1
    gradient_count = 5
    gradient_color_1 = '#0B2C7A'
    gradient_color_2 = '#1D51A8'
    gradient_color_3 = '#3C6EB4'
    gradient_color_4 = '#51A2DA'
    gradient_color_5 = '#FFFFFF'
  '';

  # Configuración declarativa de Weathr con 2 ubicaciones: Temuco y Mi Casa
  xdg.configFile."weathr/config.toml".text = ''
    [[locations]]
    name = "Temuco"
    lat = -38.5401
    lon = -72.5904

    [[locations]]
    name = "Mi Casa"
    lat = -38.6623998
    lon = -72.6373735

    [units]
    temperature = "celsius"
    speed = "kmh"
  '';

  # 🎨 CONFIGURACIÓN DE ENTORNO GNOME (DCONF) 🎨
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        pkgs.gnomeExtensions.caffeine.extensionUuid
        pkgs.gnomeExtensions.tiling-shell.extensionUuid
        pkgs.gnomeExtensions.appindicator.extensionUuid
        pkgs.gnomeExtensions.dash-to-dock.extensionUuid
      ];
    };
    "org/gnome/desktop/interface" = {
      monospace-font-name = "Monospace 10";
    };
  };

  # Versión de compatibilidad de Home Manager (Obligatoria)
  home.stateVersion = "24.11";
 
# Configuración declarativa de Cava con gradiente azul y blanco
  programs.cava = {
    enable = true;
    settings = {
      general.output = "ncurses";
      color = {
        gradient = 1;
        gradient_color_1 = "'#0000ff'"; # Azul puro/oscuro en la base
        gradient_color_2 = "'#0077ff'"; # Azul claro al medio
        gradient_color_3 = "'#00d4ff'"; # Cyan/celeste más arriba
        gradient_color_4 = "'#ffffff'"; # Blanco en los picos más altos
      };
    };
  };
}
