# haskell-project-template

My template for creating new haskell projects using cabal and nix.

## Tools You Need

You need the following tools. The rest will be installed within nix-shells.

* nix
* make
* sed
* find

## Rename Project

This runs sed to do a find and replace.

```
make change-project-name PROJECT_NAME=your-project-name
```

## Parameters

Taken from the Makefile.

```
PROJECT_NAME?=haskell-project-template

GHC_COMPILER?=ghc864

NIXPKGS_OWNER?=NixOS
NIXPKGS_REPO?=nixpkgs
NIXPKGS_REV?=7df10f388dabe9af3320fe91dd715fc84f4c7e8a

DOCKER_IMAGE_NAME?=haskell-project-template
DOCKER_IMAGE_TAG?=latest
DOCKER_PUSH_IMAGE?=false
```

## Commands

You invoke all the commands using make.

### `make build`

This sets up the proper environment and runs cabal build.

### `make run`

This sets up the proper environment and runs cabal run.

### `make test`

This sets up the proper environment and runs cabal test.

### `make nix-build`

This builds the nix derivation for the project. The result is in the file
`result`.

### `make nix-run`

Builds the nix derivation, then runs the executable (assumed to be the same
name as the project).

### `make docker-build`

This builds a docker image using nix.

### `make docker-run`

This runs the docker image.

### `make docker-push`

Attempts to push the docker image to a docker repo.

### `make update-nixpkgs`

This command uses the NIXPKGS parameters above to generate the corresponding
nixpkgs.json file needed to pin nixpkgs.

### `make available-ghc-versions`

This lists all the versions of ghc available with your pinned nixpkgs.

### `make clean`

Removes generated files.
