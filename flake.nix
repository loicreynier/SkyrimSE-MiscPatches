{
  description = "SkyrimSE mod dev environment for my misc patches";

  outputs = { self, flake-utils, nixpkgs, git-hooks, pandoc-bbcode_nexus, ... }:
    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        pandocBBCodeNexus =
          pandoc-bbcode_nexus.packages.${system}.pandoc-bbcode_nexus;
      in {
        checks = {
          pre-commit-check = git-hooks.lib.${system}.run {
            src = ./.;

            excludes = [ "^flake\\.lock$" ];

            hooks = {
              commitizen.enable = true;
              deadnix.enable = true;
              editorconfig-checker.enable = true;
              prettier.enable = true;
              markdownlint.enable = true;
              nixfmt.enable = true;
              statix.enable = true;
              typos.enable = true;
            };
          };
        };

        devShells.default = pkgs.mkShell {
          inherit (self.checks.${system}.pre-commit-check) shellHook;
          packages = with pkgs; [ just pandocBBCodeNexus zip ];
        };
      }));

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-lor = {
      url = "github:loicreynier/nixpkgs-lor";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        git-hooks.follows = "git-hooks";
      };
    };
    git-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "";
      };
    };
    pandoc-bbcode_nexus = {
      url = "github:loicreynier/pandoc-bbcode_nexus";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        pre-commit-hooks.follows = "git-hooks";
      };
    };
  };
}
