{
  description = "Configuracion Base de NixOS con Flakes y Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # 1. Agregamos el repositorio oficial del módulo declarativo de Flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  # 2. Pasamos 'nix-flatpak' como argumento en los outputs
  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... }: {
    nixosConfigurations.dangen = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Se cambió a ruta relativa (con el punto "./") para cumplir con las reglas de Git y Flakes
        ./hardware-configuration.nix

        ./configuration.nix

        # 3. Importamos el módulo de Flatpak a nivel de sistema operativo
        nix-flatpak.nixosModules.nix-flatpak

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.lab1 = import ./home.nix;
        }
      ];
    };
  };
}
