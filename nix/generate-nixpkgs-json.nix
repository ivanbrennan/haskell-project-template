with import <nixpkgs> {};

stdenv.mkDerivation rec {
  name = "generate-nixpkgs-json";

  owner="NixOS";
  repo="nixpkgs";
  sha="aebdc892d6aa6834a083fb8b56c43578712b0dab";
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
