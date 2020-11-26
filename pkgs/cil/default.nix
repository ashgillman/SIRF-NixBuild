{ stdenv
, fetchFromGitHub
, cmake
, python3
}:

let
  rev = "v20.11";
  sha256 = "0csjczj0isvw7q3zg8i8f4gy2sap3y5nmm1mzjqr8ga5dml6fbr9";
in stdenv.mkDerivation {
  name = "CIL-${rev}";

  src = fetchFromGitHub {
    owner = "vais-ral";
    repo = "CCPi-Framework";
    inherit rev sha256;
  };

  buildInputs = [ cmake python3 ];

  CIL_VERSION = "dev";
  preConfigure = ''
    cmakeFlags="-DPYTHON_DEST_DIR=$out/${python3.sitePackages} $cmakeFlags"
  '';
  pythonPath = ""; # Makes python.buildEnv include libraries

  meta = {
    description = "Core Imaging Library";
    homepage = "https://github.com/vais-ral/CCPi-Framework";
  };
}