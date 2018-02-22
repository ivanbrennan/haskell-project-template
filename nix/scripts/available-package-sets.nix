let
  pkgs = import ../nixpkgs-pinned {};

  package-sets = builtins.attrNames pkgs.haskell.packages;
in

pkgs.stdenv.mkDerivation rec {
  name = "available-package-sets";

  shellHook = ''
    set -eu

    echo "Available package sets:"
    echo -e "${builtins.concatStringsSep "\n" package-sets}"

    exit
  '';
}
