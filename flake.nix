{
  description = "Configuracion Base de NixOS con Flakes y Home Manager";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
# 1. AGREGAR ESTA LÍNEA (El módulo de Flatpaks)
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.5.0";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # 2. AGREGAR "nix-flatpak" AQUÍ ADENTRO DE LOS PARÉNTESIS
  outputs = { self, nixpkgs, home-manager, nix-flatpak, ... }: {
    nixosConfigurations.dangen = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        
        # 3. AGREGAR ESTA LÍNEA (Activa el módulo en el sistema)
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
