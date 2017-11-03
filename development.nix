{ compiler ? "ghc802" }:

let
  overrides = pkgs: haskellPackagesNew: haskellPackagesOld: rec {
    haskell-project-template = haskellPackagesNew.callPackage ./. { };
  };

  config = {
    packageOverrides = pkgs: rec {
      haskell = pkgs.haskell // {
        packages = pkgs.haskell.packages // {
          "${compiler}" = pkgs.haskell.packages."${compiler}".override {
            overrides = overrides pkgs;
          };
        };
      };
    };
  };

  bootstrap = import <nixpkgs> { };

  nixpkgs = builtins.fromJSON (builtins.readFile ./nixpkgs.json);

  src = bootstrap.fetchFromGitHub {
    inherit (nixpkgs) owner repo rev sha256 fetchSubmodules;
  };

  pkgs = import src { inherit config; };

  haskellPackages = pkgs.haskell.packages."${compiler}";

  # Specifying ghc packages this way ensures that ghc-pkg can see our packages
  ghcAndPackages = haskellPackages.ghcWithPackages (self : [
    self.cabal-install
    self.cabal2nix
    self.hpack
  ]);
in
  haskellPackages.haskell-project-template.env.overrideAttrs (old: rec {
    buildInputs = [
      pkgs.git
      ghcAndPackages
    ];

    shellHook = old.shellHook + builtins.readFile ./bash-prompt.sh + ''
      source ${pkgs.git.out}/etc/bash_completion.d/git-prompt.sh
      source ${pkgs.git.out}/etc/bash_completion.d/git-completion.bash
    '';
  })
