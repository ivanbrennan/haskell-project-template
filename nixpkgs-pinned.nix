let
  bootstrap = import <nixpkgs> { };

  nixpkgs = builtins.fromJSON (builtins.readFile ./nixpkgs.json);

  src = bootstrap.fetchFromGitHub {
    inherit (nixpkgs) owner repo rev sha256 fetchSubmodules;
  };

  pkgs = import src { };
in
  pkgs
