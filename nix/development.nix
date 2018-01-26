{ compiler ? import ./ghc.nix }:

let
  pkgs = import ./nixpkgs-pinned {};

  haskellPackages = pkgs.haskell.packages."${compiler}".override {
    overrides = new: old: {
      haskell-project-template = old.callPackage ./.. { };
    };
  };
in
  haskellPackages.haskell-project-template.env.overrideAttrs (old: rec {
    name = compiler + "-" + old.name;

    buildInputs = [
      pkgs.git
      pkgs.vim
      pkgs.ncurses # Needed by the bash-prompt.sh script
      pkgs.haskellPackages.cabal-install
    ];

    shellHook = old.shellHook + builtins.readFile ./bash-prompt.sh + ''
      source ${pkgs.git.out}/etc/bash_completion.d/git-prompt.sh
      source ${pkgs.git.out}/etc/bash_completion.d/git-completion.bash
    '';
  })
