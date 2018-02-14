{ compiler ? import ./ghc.nix }:

let
  pkgs = import ./nixpkgs-pinned { };

  haskellPackages = pkgs.haskell.packages."${compiler}".override {
    overrides = new: old: {
      haskell-project-template = old.callPackage ./.. { };
    };
  };
in
  haskellPackages.haskell-project-template
