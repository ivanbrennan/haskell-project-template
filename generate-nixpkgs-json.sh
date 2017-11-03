#!/usr/bin/env bash

NIXPKGS_OWNER=NixOS
NIXPKGS_REPO=nixpkgs
NIXPKGS_SHA=aebdc892d6aa6834a083fb8b56c43578712b0dab
NIXPKGS_URL="https://github.com/$NIXPKGS_OWNER/$NIXPKGS_REPO.git"

# Generate the data to pin our nixpkgs

nix-shell -p nix-prefetch-git \
    --run "nix-prefetch-git $NIXPKGS_URL $NIXPKGS_SHA" \
  | jq .+="{\"owner\":\"$NIXPKGS_OWNER\",\"repo\":\"$NIXPKGS_REPO\"}" \
  > nixpkgs.json
