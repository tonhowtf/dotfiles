{

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
    
    ghostty-themes = {
      url = "github:nyxvamp-theme/ghostty";
      flake = false;
    };
    
    helix-themes = {
      url = "github:nyxvamp-theme/helix";
      flake = false;
    };
    
    bat-themes = {
      url = "github:nyxvamp-theme/bat";
      flake = false;
    };
    
    starship-themes = {
      url = "github:nyxvamp-theme/starship";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, ghostty, ... } @ inputs: 
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        
        specialArgs = { 
          inherit inputs;
          ghostty-themes = inputs.ghostty-themes;
          helix-themes = inputs.helix-themes;
          bat-themes = inputs.bat-themes;
          starship-themes = inputs.starship-themes;
        };
        
        modules = [
          ./hosts/tonhowtf/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              
              extraSpecialArgs = {
                inherit inputs;
                ghostty-pkg = ghostty.packages.${system}.default;
                ghostty-themes = inputs.ghostty-themes;
                helix-themes = inputs.helix-themes;
                bat-themes = inputs.bat-themes;
                starship-themes = inputs.starship-themes;
              };
              
              users.tonhowtf = import ./hosts/tonhowtf/home.nix;
            };
          }
        ];
      };
    };
}
