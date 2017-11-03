{ compiler ? "ghc802" }:

let
  bootstrap = import <nixpkgs> { };

  nixpkgs = builtins.fromJSON (builtins.readFile ./nixpkgs.json);

  src = bootstrap.fetchFromGitHub {
    inherit (nixpkgs) owner repo rev sha256 fetchSubmodules;
  };

  pkgs = import src { };

  haskellPackages = pkgs.haskell.packages."${compiler}".override {
    overrides = new: old: {
      haskell-project-template = old.callPackage ./. { };
    };
  };

  # Specifying ghc packages this way ensures that ghc-pkg can see our packages
  ghcAndPackages = haskellPackages.ghcWithPackages (self : [
    self.haskell-project-template
    self.cabal-install
    self.cabal2nix
    self.hpack
  ]);
in
  pkgs.stdenv.mkDerivation {
    name = "haskell-project-template-release";

    buildInputs = [
      ghcAndPackages
    ];

    shellHook = builtins.readFile ./bash-prompt.sh + ''
      source ${pkgs.git.out}/etc/bash_completion.d/git-prompt.sh
      source ${pkgs.git.out}/etc/bash_completion.d/git-completion.bash
    '';
  }
