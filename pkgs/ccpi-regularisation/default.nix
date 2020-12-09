{ stdenv
, fetchFromGitHub
, cmake
, python3
, setuptools
, cython
, numpy
}:

let
  rev = "v20.09";
  sha256 = "0h5givlrnr2qr4547h0lf4advmkizl71vgfsiyx94hz6f2k6p715";
in stdenv.mkDerivation {
  name = "CCPi-RGL-${rev}";

  src = fetchFromGitHub {
    owner = "vais-ral";
    repo = "CCPi-Regularisation-Toolkit";
    inherit rev sha256;
  };

  buildInputs = [ cmake python3 setuptools cython ];
  propagatedBuildInputs = [ numpy ];

  CIL_VERSION = rev;
  preConfigure = ''
    cmakeFlags="-DPYTHON_DEST_DIR=$out/${python3.sitePackages} $cmakeFlags"
  '';
  pythonPath = ""; # Makes python.buildEnv include libraries

  meta = {
    description = "Core Imaging Library";
    homepage = "https://github.com/vais-ral/CCPi-Framework";
  };
}