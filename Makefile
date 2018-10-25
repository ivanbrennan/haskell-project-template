PROJECT_NAME?=haskell-project-template

GHC_COMPILER?=ghc843

NIXPKGS_OWNER?=NixOS
NIXPKGS_REPO?=nixpkgs
NIXPKGS_REV?=7df10f388dabe9af3320fe91dd715fc84f4c7e8a

DOCKER_IMAGE_NAME?=haskell-project-template
DOCKER_IMAGE_TAG?=latest
DOCKER_PUSH_IMAGE?=false

.PHONY: build
build: default.nix haskell-project-template.cabal
	nix-shell --pure nix \
		--attr devel \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })' \
		--run "cabal build"

.PHONY: run
run: default.nix haskell-project-template.cabal
	nix-shell --pure nix \
		--attr devel \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })' \
		--run "cabal run"

.PHONY: test
test: default.nix haskell-project-template.cabal
	nix-shell --pure nix \
		--attr devel \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })' \
		--run "cabal test --show-details=direct"

haskell-project-template.cabal: package.yaml
	nix-shell --pure nix/scripts/generate-cabal-file.nix \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })'

default.nix: package.yaml haskell-project-template.cabal
	nix-shell --pure nix/scripts/generate-default-nix-file.nix \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })'

.PHONY: nix-build
nix-build: default.nix haskell-project-template.cabal
	nix-build nix \
		--attr full \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })'

.PHONY: nix-run
nix-run: nix-build
	./result/bin/haskell-project-template

.PHONY: docker-build
docker-build:
	make --check-symlink-times docker-image.tar.gz

.PHONY: docker-run
docker-run: docker-build
	docker run --rm $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

.PHONY: docker-push
docker-push: docker-build
	docker push $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

docker-image.tar.gz: default.nix haskell-project-template.cabal
	nix-build nix/docker-image.nix --out-link docker-image.tar.gz \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })' \
		--argstr image-name $(DOCKER_IMAGE_NAME) \
		--argstr image-tag $(DOCKER_IMAGE_TAG)
	docker load -i 'docker-image.tar.gz'

.PHONY: update-nixpkgs
update-nixpkgs:
	nix-shell --pure nix/scripts/generate-nixpkgs-json.nix \
		--argstr owner $(NIXPKGS_OWNER) \
		--argstr repo $(NIXPKGS_REPO) \
		--argstr rev $(NIXPKGS_REV)

.PHONY: available-ghc-versions
available-ghc-versions:
	nix-shell nix/scripts/available-ghc-versions.nix \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })'

.PHONY: change-project-name
change-project-name: clean
	find . -type f -not -path './.git/*' -not -name '*.swp' \
		| xargs -r sed -i -e "s/haskell-project-template/$(PROJECT_NAME)/g"

.PHONY: clean
clean:
	rm -rf dist
	rm -f default.nix
	rm -f haskell-project-template.cabal
	rm -f result
	rm -f docker-image.tar.gz
