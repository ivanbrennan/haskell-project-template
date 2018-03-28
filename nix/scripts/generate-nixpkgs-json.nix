{ owner ? "NixOS"
, repo ? "nixpkgs"
, rev
}:

let
  pkgs = import <nixpkgs> {};

  url="https://github.com/${owner}/${repo}/archive/${rev}.tar.gz";

  file = if (0 <= builtins.compareVersions builtins.nixVersion "1.12")
    then
      builtins.fetchTarball { url = url; }
    else
      builtins.fetchurl url;
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
    sha256=$(nix-hash --type sha256 --base32 ${file})
    jq .+="{\"sha256\":\"$sha256\"}" ${json} > ${out-filename}
    exit
  '';
}
