{ config, pkgs, ... }: {
  home.username = "lab1";
  home.homeDirectory = "/home/lab1";

  home.stateVersion = "24.11";

home.packages = [
    pkgs.git
  ];

  # Configuración declarativa de Git con tus datos oficiales
  programs.git = {
    enable = true;
    userName = "WillyDoc";
    userEmail = "guillermoreyno@institutoclaret.cl";
  };

  programs.home-manager.enable = true;
}
