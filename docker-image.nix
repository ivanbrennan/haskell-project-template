{ compiler ? "ghc802" }:

let
  overlay = self: super: {
    haskell.packages."${compiler}" = super.haskell.packages."${compiler}".override {
      overrides = new: old: {
        haskell-project-template =
          super.haskell.lib.justStaticExecutables
            (old.callPackage ./. { });
      };
    };
  };

  bootstrap = import <nixpkgs> { };

  nixpkgs = builtins.fromJSON (builtins.readFile ./nixpkgs.json);

  src = bootstrap.fetchFromGitHub {
    inherit (nixpkgs) owner repo rev sha256 fetchSubmodules;
  };

  pkgs = import src { overlays = [ overlay ]; };

  haskellPackages = pkgs.haskell.packages."${compiler}";
in
  pkgs.dockerTools.buildImage {
    name = "haskell-project-template-image";
    tag = "latest";

    contents = [
      haskellPackages.haskell-project-template
    ];

    config = {
      Entrypoint = [
        "haskell-project-template"
      ];

      Env = [
        "VAR1=var1"
        "VAR2=var2"
      ];
    };
  }
