{
  description = "My personal collection of flake templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = { self, nixpkgs, flake-utils, pre-commit-hooks }: {
    templates = {

      python = {
        path = ./python;
        description = "A python flake template";
        welcomeText = ''
          ToDo
        '';
      };

      trivial = {
        path = ./trivial;
        description = "A trivial flake template";
        welcomeText = ''
          ToDo
        '';
      };
    };
    defaultTemplate = self.templates.trivial;
  } // flake-utils.lib.eachDefaultSystem (
    system:
    let pkgs = import nixpkgs { inherit system; };
    in {
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixpkgs-fmt.enable = true;
          };
        };
      };
      devShell = with pkgs; mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };
    }
  );
}
