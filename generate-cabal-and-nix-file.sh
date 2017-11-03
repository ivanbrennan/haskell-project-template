#!/usr/bin/env bash

NIXPKGS_PINNED='(import ./nixpkgs-pinned.nix)'

# Generate the cabal file from the hpack yaml file
nix-shell -p "$NIXPKGS_PINNED.haskellPackages.hpack" --run hpack

# Generate the nix file from the cabal file
nix-shell -p "$NIXPKGS_PINNED.cabal2nix" --run 'cabal2nix .' > default.nix
