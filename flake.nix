{
  description = "Carbon Colours for Gitea";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    palette.url = "github:carbon-colours/palette";
  };

  outputs = inputs: let
    inherit (inputs.nixpkgs) lib;
    systems = lib.systems.flakeExposed;

    forEachSystem = f:
      lib.genAttrs systems
      (system: f system inputs.nixpkgs.legacyPackages.${system});
  in {
    lib = import ./lib.nix;

    packages = forEachSystem (system: pkgs: {
      default = pkgs.callPackage ./package.nix {inherit system inputs;};
    });

    formatter = forEachSystem (_: pkgs: pkgs.alejandra);
  };
}
