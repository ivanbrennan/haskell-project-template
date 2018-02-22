{ owner ? "NixOS"
, repo ? "nixpkgs"
, rev ? "16210c39962b14bd90b83586221716f65da06c6d"
}:

let
  pkgs = import <nixpkgs> {};

  url="https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";

  file = builtins.fetchurl url;
  json = builtins.toFile "data.json" ''
    { "url": "${url}"
    , "rev": "${rev}"
    , "owner": "${owner}"
    , "repo": "${repo}"
    }
  '';

  out-filename = builtins.toString ../nixpkgs-pinned/nixpkgs.json;
in


pkgs.stdenv.mkDerivation rec {
  name = "generate-nixpkgs-json";

  buildInputs = [
    pkgs.jq
  ];


  shellHook = ''
    set -eu
    sha256=$(sha256sum -b ${file} | awk -n '{printf $1}')
    jq .+="{\"sha256\":\"$sha256\"}" ${json} > ${out-filename}
    exit
  '';
}
