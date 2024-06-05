{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let

        pkgs = import nixpkgs { inherit system; };

        packaged-python = pkgs.python3.withPackages (p: with p; [
          # Examples
          numpy
          jupyter
          pillow
          pip
        ]);

      in {
        packages = { };
        apps = { };

        devShells.default =
          pkgs.mkShell {
            name = "Python Shell";
            shellHook = ''
              python -m venv venv
              source ./venv/bin/activate
              python -m ipykernel install --user --name=venv
            '';
            packages = with pkgs; [
              packaged-python
              pkgs.nix-init
              pkgs.virtualenv
              poppler_utils
            ];
          };
      }
    );
}
