{ config, pkgs, ... }: {
  home.username = "lab1";
  home.homeDirectory = "/home/lab1";

  home.stateVersion = "24.11";


  # Tus aplicaciones personales del día a día
  home.packages = [
    pkgs.git                        # Herramienta de control de versiones
    pkgs.brave-origin               # Navegador web enfocado en privacidad
    pkgs.keepassxc                  # Gestor de contraseñas local y seguro
    pkgs.onlyoffice-desktopeditors   # Suite ofimática compatible con Office
    pkgs.proton-authenticator       # Generador de códigos 2FA de Proton
  ];

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

  programs.home-manager.enable = true;
}
