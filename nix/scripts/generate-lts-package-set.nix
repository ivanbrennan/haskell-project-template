{ lts-version ? "lts-2.22" }:

let
  pkgs = import ../nixpkgs-pinned {};

  project-root = import ../project-root.nix;

  lts-haskell = import ../util/lts-haskell {};
  all-cabal-hashes = import ../util/all-cabal-hashes {};

  path = "${project-root}/nix/lts-package-sets/${lts-version}";
in

pkgs.stdenv.mkDerivation rec {
  name = "generate-lts-package-set";


  buildInputs = [
    pkgs.haskellPackages.stackage2nix
    pkgs.haskellPackages.cabal-install
    #    (pkgs.haskellPackages.callHackage "stackage2nix" "0.4.0" {})
  ];

  shellHook = ''
    set -eu

    if [ ! -e "${lts-haskell}/${lts-version}.yaml" ]; then
      echo "Cannot find lts version ${lts-version}"
      exit
    fi

    mkdir -p ${path}

    echo -e "Running stackage2nix to generate lts package set ...\n"
    cabal update
    stackage2nix \
      --resolver ${lts-version} \
      --lts-haskell ${lts-haskell} \
      --all-cabal-hashes ${all-cabal-hashes} \
      --out-derivation ${path}/default.nix \
      --out-packages ${path}/packages.nix \
      --out-config ${path}/configuration-packages.nix \
      --nixpkgs "${project-root}/nix/nixpkgs-pinned"

    exit
  '';
}
