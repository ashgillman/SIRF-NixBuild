{ stdenv
, fetchFromGitHub
, cmake
, python3
}:

let
  rev = "a28f794ad3e3c22ddcf4969624fac5ce93c4aa54";
  sha256 = "00nq36ddh772jd6135qljwnvkys372dja1nilkny1172lavkl3yj";
in stdenv.mkDerivation {
  name = "CIL-${rev}";

  src = fetchFromGitHub {
    owner = "vais-ral";
    repo = "CCPi-Framework";
    inherit rev sha256;
  };

  buildInputs = [ cmake python3 ];

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