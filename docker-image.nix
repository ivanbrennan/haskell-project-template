{ compiler ? "ghc802" }:

let
  overrides = pkgs: haskellPackagesNew: haskellPackagesOld: rec {
    # Just the executable so our docker image drops down to 27 mb from 1.5 gb
    haskell-project-template =
      pkgs.haskell.lib.justStaticExecutables
        (haskellPackagesNew.callPackage ./. { });
  };

  config = {
    packageOverrides = pkgs: rec {
      haskell = pkgs.haskell // {
        packages = pkgs.haskell.packages // {
          "${compiler}" = pkgs.haskell.packages."${compiler}".override {
            overrides = overrides pkgs;
          };
        };
      };
    };
  };

  bootstrap = import <nixpkgs> { };

  nixpkgs = builtins.fromJSON (builtins.readFile ./nixpkgs.json);

  src = bootstrap.fetchFromGitHub {
    inherit (nixpkgs) owner repo rev sha256 fetchSubmodules;
  };

  pkgs = import src { inherit config; };

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
