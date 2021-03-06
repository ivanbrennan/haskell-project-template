{ mkDerivation, base, hpack, hspec, stdenv }:
mkDerivation {
  pname = "haskell-project-template";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base hspec ];
  preConfigure = "hpack";
  homepage = "https://github.com/srdqty/haskell-project-template#readme";
  license = stdenv.lib.licenses.bsd3;
}
