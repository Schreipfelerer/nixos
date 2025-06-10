{
    description = "My nix config";

    inputs = {
        # Nixpkgs
        nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

        # Home manager
        home-manager.url = "github:nix-community/home-manager/release-25.05";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        # NixOS Hardware
        nixos-hardware.url = "github:NixOS/nixos-hardware/master";

        # Secure Boot Stuff
        lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
        lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

        # Stylix
        stylix.url = "github:nix-community/stylix/release-25.05";
    };

    outputs = {
        self,
        nixpkgs,
        home-manager,
        nixos-hardware,
        stylix,
        ...
    } @ inputs: let
        inherit (self) outputs;
    in {
        # NixOS configuration entrypoint
        # Available through 'nixos-rebuild --flake .#your-hostname'
        nixosConfigurations = {
            framy = nixpkgs.lib.nixosSystem {
                specialArgs = {inherit inputs outputs;};
                # > Our main nixos configuration file <
                modules = [
                    ./framy/configuration.nix
                    home-manager.nixosModules.home-manager
                    nixos-hardware.nixosModules.framework-11th-gen-intel
                    inputs.lanzaboote.nixosModules.lanzaboote
                    stylix.nixosModules.stylix
                ];
            };
	    jinx = nixpkgs.lib.nixosSystem {
		specialArgs = {inherit inputs outputs;};
		modules = [
		    ./jinx/configuration.nix
		];
	    }
        };
    };
}
