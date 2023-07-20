{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = { self, nixpkgs, flake-utils, pre-commit-hooks }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixpkgs-fmt.enable = true;
              gofmt.enable = true;
              gotest.enable = true;
              govet.enable = true;
              staticcheck.enable = true;
            };
          };
        };
        devShell = with pkgs; mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          buildInputs = [ go gotools go-tools ];
        };
        defaultPackage = with pkgs; buildGoModule {
          pname = "go-hello";
          version = "0.1.0";
          src = ./.;

          vendorSha256 = null;
        };

      });
}
