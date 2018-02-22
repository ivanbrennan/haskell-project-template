let
  pkgs = import ../nixpkgs-pinned {};

  lts-haskell = import ../util/lts-haskell {};
in

pkgs.stdenv.mkDerivation rec {
  name = "available-lts-versions";

  shellHook = ''
    set -eu

    echo "Available lets versions:"
    cd ${lts-haskell}
    ls lts* | sed 's/.yaml//g' | sort

    exit
  '';
}
