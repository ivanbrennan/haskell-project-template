with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "project-root";

  PROJECT_ROOT = builtins.toString ../.;

  shellHook = ''
    echo $PROJECT_ROOT
    exit
  '';
}
