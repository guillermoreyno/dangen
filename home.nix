{ pkgs, ... }:

{
  # Tus aplicaciones personales (Manteniendo tus herramientas y añadidos nuevos)
  home.packages = [
    pkgs.git                        # Herramienta de control de versiones
    pkgs.brave-origin               # Versión de Brave limpia (sin Bloatware/AI/Wallet)
   # pkgs.keepassxc                  # Gestor de contraseñas local y seguro
   # pkgs.onlyoffice-desktopeditors   # Suite ofimática compatible con Office
    pkgs.proton-authenticator       # Generador de códigos 2FA de Proton
   # pkgs.materialgram               # Cliente alternativo de Telegram
    pkgs.ptyxis                     # Tu terminal predeterminada
    pkgs.handbrake

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
    pkgs.btop	
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
      clima = "curl 'wttr.in/Temuco,Chile?m' && curl 'wttr.in/-38.6623998,-72.6373735'";
      f = "fastfetch";
      acuario = "asciiquarium";
    };
	initExtra = ''
      function sys-update {
        local flake_path="path:/home/lab1/nixos-config"

        echo "Updating flake..."
        nix flake update --flake "$flake_path" && \
        echo "Rebuilding NixOS..." && \
        sudo nixos-rebuild switch --flake "$flake_path#dangen" && \
        echo "Restarting Flatpak service..." && \
        sudo systemctl restart flatpak-managed-install.service && \
        echo "Updating Flatpaks..." && \
        flatpak update -y
      }
      alias up="sys-update"

      # Ejecuta tu diseño personalizado de Fastfetch al abrir la terminal
      fastfetch

      # Mensaje recordatorio de Git para tu repositorio dangen
      echo -e "\n\e[1;34m💡 Recordatorio de Git (Respaldar configuraciones):\e[0m"
      echo "git add ~/nixos-config/home.nix"
      echo "up"
      echo "git add ."
      echo "git commit -m \"TEXTO CORTO QUE DIGA EL CAMBIO\""
      echo "git push"
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
    Exec=flatpak run io.github.kukuruzka165.materialgram
    Hidden=false
    NoDisplay=false
    X-GNOME-Autostart-enabled=true
  '';

xdg.configFile."autostart/ch.threema.threema-desktop.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Threema
    Exec=flatpak run ch.threema.threema-desktop
    Icon=ch.threema.threema-desktop
    Terminal=false
    Categories=Network;InstantMessaging;
    X-GNOME-Autostart-enabled=true
  '';


# ⚙️ CONFIGURACIÓN DECLARATIVA DE FASTFETCH (NixOS Style) ⚙️
  xdg.configFile."fastfetch/config.jsonc".text = ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
      "display": {
        "separator": " ➜ "
      },
      "modules": [
        "title",
        {
          "type": "custom",
          "format": "\u001b[38;5;51m┌─────────────────────────────────────────────────────────────┐\u001b[0m"
        },
        {
          "type": "os",
          "key": "\u001b[38;5;51m│\u001b[0m 🐧 OS",
          "format": "{3}"
        },
        {
          "type": "host",
          "key": "\u001b[38;5;51m│\u001b[0m 💻 Host"
        },
        {
          "type": "kernel",
          "key": "\u001b[38;5;51m│\u001b[0m 🎛️ Kernel"
        },
        {
          "type": "uptime",
          "key": "\u001b[38;5;51m│\u001b[0m ⏱️ Uptime"
        },
        {
          "type": "packages",
          "key": "\u001b[38;5;51m│\u001b[0m 📦 Pkgs",
          "flatpak": true
        },
        {
          "type": "shell",
          "key": "\u001b[38;5;51m│\u001b[0m 🐚 Shell"
        },
        {
          "type": "de",
          "key": "\u001b[38;5;51m│\u001b[0m 🖥️ DE"
        },
        {
          "type": "wm",
          "key": "\u001b[38;5;51m│\u001b[0m 🪟 WM"
        },
        {
          "type": "terminal",
          "key": "\u001b[38;5;51m│\u001b[0m 📟 Term"
        },
        {
          "type": "display",
          "key": "\u001b[38;5;51m│\u001b[0m 📺 Res"
        },
        {
          "type": "cpu",
          "key": "\u001b[38;5;51m│\u001b[0m 🧠 CPU",
          "showPeCoreCount": false,
          "temp": false
        },
        {
          "type": "gpu",
          "key": "\u001b[38;5;51m│\u001b[0m 🎮 GPU",
          "format": "{1} {2}"
        },
        {
          "type": "memory",
          "key": "\u001b[38;5;51m│\u001b[0m 🧪 RAM"
        },
        {
          "type": "swap",
          "key": "\u001b[38;5;51m│\u001b[0m 🔄 Swap"
        },
        {
          "type": "disk",
          "key": "\u001b[38;5;51m│\u001b[0m 💽 Disk"
        },
        {
          "type": "localip",
          "key": "\u001b[38;5;51m│\u001b[0m 🌐 IP"
        },
        {
          "type": "custom",
          "format": "\u001b[38;5;51m└─────────────────────────────────────────────────────────────┘\u001b[0m"
        },
        "break",
        "colors"
      ]
    }
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
    lon = -72.4825090
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
      font-name = "Monospace 10";
      document-font-name = "Monospace 10";
      monospace-font-name = "Monospace 10";
    };
  };

  # 📊 CONFIGURACIÓN DECLARATIVA DE CAVA (Módulo Oficial) 📊
  programs.cava = {
    enable = true;
    settings = {
      general = {
        bars = 0;
        bar_width = 1;
        bar_spacing = 1;
      };
      output.method = "ncurses";
      color = {
        gradient = 1;
        gradient_count = 5;
        gradient_color_1 = "'#0B2C7A'"; # Tu azul oscuro original de base
        gradient_color_2 = "'#1D51A8'";
        gradient_color_3 = "'#3C6EB4'";
        gradient_color_4 = "'#51A2DA'";
        gradient_color_5 = "'#FFFFFF'"; # Tu blanco en los picos altos
      };
    };
  };

  # Versión de compatibilidad de Home Manager (Obligatoria)
  home.stateVersion = "24.11";
}

