with import ./nixpkgs-pinned.nix;

stdenv.mkDerivation rec {
  name = "build-docker-image";

  project-root = builtins.toString ../.;

  # Docker is a system service anyway, so just assume it's installed instead of
  # bothering with buildInputs.

  shellHook = ''
    nix-build '${project-root}/nix/docker-image.nix' \
      --out-link '${project-root}/docker-image.tar.gz'

    docker load -i '${project-root}/docker-image.tar.gz'

    exit
  '';
}
