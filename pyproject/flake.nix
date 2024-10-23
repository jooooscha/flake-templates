{
  description = "A basic flake using pyproject.toml project metadata";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";

    pyproject-nix = {
      url = "github:nix-community/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, pyproject-nix, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (nixpkgs) lib;

        # Loads pyproject.toml into a high-level project representation
        # Do you notice how this is not tied to any `system` attribute or package sets?
        # That is because `project` refers to a pure data representation.
        project = pyproject-nix.lib.project.loadPyproject {
          # Read & unmarshal pyproject.toml relative to this project root.
          # projectRoot is also used to set `src` for renderers such as buildPythonPackage.
          projectRoot = ./.;
        };

        # This example is only using x86_64-linux
        pkgs = import nixpkgs {
          system = system;
          # overlays = [
          #   # overriding python3 to include simplematrixbotlib
          #   (final: prev: {
          #      python3 = prev.python3.override {
          #        packageOverrides = pyfinal: pyprev: {
          #          simplematrixbotlib = simplematrixbotlib;
          #        };
          #      };
          #   })
          # ];
          # config.permitedInsecurePackages = [ ];
        };

        # We are using the default nixpkgs Python3 interpreter & package set.
        #
        # This means that you are purposefully ignoring:
        # - Version bounds
        # - Dependency sources (meaning local path dependencies won't resolve to the local path)
        #
        # To use packages from local sources see "Overriding Python packages" in the nixpkgs manual:
        # https://nixos.org/manual/nixpkgs/stable/#reference
        #
        # Or use an overlay generator such as pdm2nix:
        # https://github.com/adisbladis/pdm2nix
        python = pkgs.python3;

        ## When generating packages with nix-init we would like to use callPackage to import them
        ## When the generated package requries python tools, we can import them automatically
        ## with the following line:

        # callPackage = pkgs.lib.callPackageWith (pkgs // pkgs.python3Packages);

      in
      {
        # Create a development shell containing dependencies from `pyproject.toml`
        devShells.default =
          let
            # Returns a function that can be passed to `python.withPackages`
            arg = project.renderers.withPackages { inherit python; };

            # Returns a wrapped environment (virtualenv like) with all our packages
            pythonEnv = python.withPackages arg;

          in
          # Create a devShell like normal.
          pkgs.mkShell {
            packages = [ pythonEnv ];
          };

        # Build our package using `buildPythonPackage
        packages.default =
          let
            # Returns an attribute set that can be passed to `buildPythonPackage`.
            attrs = project.renderers.buildPythonPackage { inherit python; };
          in
          # Pass attributes to buildPythonPackage.
            # Here is a good spot to add on any missing or custom attributes.
          python.pkgs.buildPythonPackage (attrs // {
            env.CUSTOM_ENVVAR = "hello";
          });
      }
    );
}
