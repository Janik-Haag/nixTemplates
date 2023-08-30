{
  description = "replaceMe";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = { self, nixpkgs, flake-utils, poetry2nix, pre-commit-hooks, ... }:
    flake-utils.lib.eachDefaultSystem
      (
        system:
        let
          pkgs = import nixpkgs { inherit system; overlays = [ poetry2nix.overlay ]; };
        in
        {
          checks = {
            pre-commit-check = pre-commit-hooks.lib.${system}.run {
              src = ./.;
              hooks = {
                nixpkgs-fmt.enable = true;
                isort.enable = true;
                black.enable = true;
                #autoflake.enable = true;
                flake8.enable = true;
              };
            };
          };
          defaultPackage = pkgs.python3.pkgs.buildPythonApplication {
            pname = "replaceMe";
            version = "0.0.1";
            format = "pyproject";

            src = ./.;

            nativeBuildInputs = with pkgs; [
              python3Packages.poetry-core
            ];


          };

          devShell = pkgs.mkShell {
            inherit (self.checks.${system}.pre-commit-check) shellHook;
            buildInputs = with pkgs; [
              poetry
            ];
          };
        }
      );
}

