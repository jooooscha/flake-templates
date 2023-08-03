{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages = { };
        apps = { };

        devShells = {
          default = pkgs.mkShell {
            name = "Nix Shell for Rust";
            packages = with pkgs; [
              cargo
              cargo-edit
              pkg-config
            ];
          };
        };
      }
    );
}
