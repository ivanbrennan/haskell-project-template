{ config ? {}
, rev ? "98042ee2b35aa6ac20e9abc64f154f706e4adb4a"
}:

let
  pkgs = import ../../nixpkgs-pinned { inherit config; };
in
  pkgs.fetchgit {
    url = "https://github.com/fpco/lts-haskell";
    rev = rev;
    sha256 = "0b731g1k85wbsrk1cqz2xs613d742gcr1cia4ccdxa790x2552m0";
  }
