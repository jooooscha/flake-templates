{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = false;
        };
      in {
        packages = { };
        apps = { };

        devShells = {
          default = pkgs.mkShell {
            name = "Nix Shell";
            packages = with pkgs; [
            ];
            shellHook = ''
            '';
          };
        };
      }
    );
}
