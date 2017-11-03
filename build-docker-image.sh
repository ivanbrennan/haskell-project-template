#!/usr/bin/env bash

set -eu

rm -f ./result
nix-build ./docker-image.nix
docker load -i ./result
