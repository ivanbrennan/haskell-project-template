{ compiler ? "ghc802" }:

let
  pkgs = import ./nixpkgs-pinned.nix { };

  haskellPackages = pkgs.haskell.packages."${compiler}".override {
    overrides = new: old: {
      haskell-project-template = old.callPackage ./.. { };
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
      pkgs.ncurses # Needed by the bash-prompt.sh script.
      ghcAndPackages
    ];

    shellHook = builtins.readFile ./bash-prompt.sh + ''
      source ${pkgs.git.out}/etc/bash_completion.d/git-prompt.sh
      source ${pkgs.git.out}/etc/bash_completion.d/git-completion.bash
    '';
  }
