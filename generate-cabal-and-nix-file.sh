#!/usr/bin/env bash

# Generate the cabal file from the hpack yaml file
nix-shell -p haskellPackages.hpack --run hpack

# Generate the nix file from the cabal file
nix-shell -p cabal2nix --run 'cabal2nix .' > default.nix
