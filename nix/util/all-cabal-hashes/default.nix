{ config ? {}
, rev ? "16d778d12fa6761b9a47ad64b8942d46a1c725d8"
}:

let
  pkgs = import ../../nixpkgs-pinned { inherit config; };
in
  pkgs.fetchgit {
    url = "https://github.com/commercialhaskell/all-cabal-hashes";
    rev = rev;
    sha256 = "1p7lxhp4dy8r2rk5j9bywz2bch0vcad2ndqnlz0yyarh0hwmk03p";
  }
