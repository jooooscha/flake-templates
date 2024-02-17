{

  description = "Basic Poetry Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix, ... }:
    let
      inherit (flake-utils.lib)
        filterPackages
        eachSystem
        mkApp;

      systems = [  "aarch64-linux" "aarch64-darwin" "x86_64-darwin" "x86_64-linux" ];

    in eachSystem systems (system:

      let

        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlays.default ];
        };

        inherit (pkgs)
          callPackage
          runCommandNoCC;

        inherit (pkgs.lib)
          mapAttrsToList;

        inherit (poetry2nix.legacyPackages.${system})
          mkPoetryApplication;

        peotry-project = mkPoetryApplication {
          projectDir = ./.;
          buildInputs = [];
        };

  in {
    packages = { };

    apps = {
      default = mkApp {
        drv = update-vim-plugins;
      };
    };

    devShells = {
      default = pkgs.mkShell {
        inherit (update-vim-plugins) buildInputs;
      };
      pythonEnv = pkgs.mkShell {
        name = "Python Env";
        packages = with pkgs; let
          python-with-packages = pkgs.python3.withPackages (p: with p; [
            requests
          ]);
        in [
          python-with-packages
          alejandra
        ];
      };
    };
  };

}
