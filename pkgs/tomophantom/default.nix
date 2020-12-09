{ stdenv
, fetchFromGitHub
, cmake
, python3
, cython
, numpy
}:

let
  rev = "v1.4.7";
  sha256 = "14c7d6h1q67w62snwc965m13np1np4rfm0m4jgxalyzdjqj7qmz6";
in stdenv.mkDerivation {
  name = "tomophantom-${rev}";

  src = fetchFromGitHub {
    owner = "dkazanc";
    repo = "TomoPhantom";
    inherit rev sha256;
  };

  buildInputs = [ cmake python3 cython ];
  propagatedBuildInputs = [ numpy ];

  preConfigure = ''
    cmakeFlags="-DPYTHON_DEST_DIR=$out/${python3.sitePackages} $cmakeFlags"
  '';
  pythonPath = ""; # Makes python.buildEnv include libraries
}
