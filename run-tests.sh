#!/usr/bin/env bash

set -eu

nix-shell --pure nix/development.nix --run "cabal test --show-details=direct"
