{ nixpkgs, image-name, image-tag }:

let
  release = import ./default.nix { inherit nixpkgs; };
in
  nixpkgs.dockerTools.buildImage {
    name = image-name;
    tag = image-tag;

    contents = [
      release.static-executable
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
