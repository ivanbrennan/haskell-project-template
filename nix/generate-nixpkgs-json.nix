with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "generate-nixpkgs-json";

  owner="NixOS";
  repo="nixpkgs";
  sha="eac38d0b1e68b4ae4f0b78fe778b61d0f314ae7a";
  url="https://github.com/${owner}/${repo}.git";

  project-root = builtins.toString ../.;

  buildInputs = [
    nix-prefetch-git
    jq
  ];

  shellHook = ''
    nix-prefetch-git '${url}' '${sha}' \
    | jq .+='{"owner":"${owner}","repo":"${repo}"}' \
    > ${project-root}/nix/nixpkgs.json
    exit
  '';
}
