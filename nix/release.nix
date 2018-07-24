{ compiler ? import ./ghc.nix }:

let
  haskellOverrides = pkgs: new: old: {
    haskell-project-template = old.callPackage ./.. { };
  };

  overlays = import ./overlays.nix {
    compiler = compiler;
    extraHaskellOverride = haskellOverrides;
  };

  pkgs = import ./nixpkgs-pinned {
    overlays = overlays;
  };
in
  pkgs.haskellPackages.haskell-project-template
