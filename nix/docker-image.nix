{ compiler ? "ghc802"
, image-name
, image-tag
}:

let
  pkgs = import ./nixpkgs-pinned.nix {};

  haskellPackages = pkgs.haskell.packages."${compiler}".override {
    overrides = new: old: {
      haskell-project-template =
        pkgs.haskell.lib.justStaticExecutables
          (old.callPackage ../. { });
    };
  };
in
  pkgs.dockerTools.buildImage {
    name = image-name;
    tag = image-tag;

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
