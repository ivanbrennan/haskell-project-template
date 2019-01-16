PROJECT_NAME?=haskell-project-template

GHC_COMPILER?=ghc844

NIXPKGS_OWNER?=NixOS
NIXPKGS_REPO?=nixpkgs
NIXPKGS_REV?=80738ed9dc0ce48d7796baed5364eef8072c794d

DOCKER_IMAGE_NAME?=haskell-project-template
DOCKER_IMAGE_TAG?=latest
DOCKER_PUSH_IMAGE?=false

.PHONY: build
build: default.nix haskell-project-template.cabal
	nix-shell --pure nix \
		--attr devel \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })' \
		--run "cabal new-build"

.PHONY: run
run: default.nix haskell-project-template.cabal
	nix-shell --pure nix \
		--attr devel \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })' \
		--run "cabal new-run haskell-project-template"

.PHONY: repl-lib
repl-lib: default.nix haskell-project-template.cabal
	nix-shell --pure nix \
		--attr devel \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })' \
		--run "cabal new-repl haskell-project-template"

.PHONY: repl-exe
repl-exe: default.nix haskell-project-template.cabal
	nix-shell --pure nix \
		--attr devel \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })' \
		--run "cabal new-repl exe:haskell-project-template"

.PHONY: test
test: default.nix haskell-project-template.cabal
	nix-shell --pure nix \
		--attr devel \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })' \
		--run "cabal new-run haskell-project-template-test"

.PHONY: dump-ghc-core
dump-ghc-core: default.nix haskell-project-template.cabal
	nix-shell --pure nix \
		--attr devel \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })' \
		--run "cabal new-build -fdump-ghc-core"

.PHONY: list-ghc-core-files
list-ghc-core-files:
	find . -name '*.dump-simpl'

haskell-project-template.cabal: package.yaml
	nix-shell --pure nix/scripts/generate-cabal-file.nix \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })'

default.nix: package.yaml haskell-project-template.cabal
	nix-shell --pure nix/scripts/generate-default-nix-file.nix \
		--arg nixpkgs '(import nix/nixpkgs { compiler = "$(GHC_COMPILER)"; })'

.PHONY: nix-shell
nix-shell: default.nix haskell-project-template.cabal
	nix-shell nix \
		--attr shell \
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
	rm -rf dist-newstyle
	rm -f .ghc.environment.*
	rm -f default.nix
	rm -f haskell-project-template.cabal
	rm -f result
	rm -f docker-image.tar.gz
