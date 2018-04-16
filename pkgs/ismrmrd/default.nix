{ stdenv
, fetchFromGitHub
, cmake
, boost
, fftw
, hdf5-cpp
}:

let
  ver = "v1.3.3";
  sha256 = "0vyif4l3k5ad07y6ycjzqak24ivpf5848lw9g570k2pj98i7r223";

in stdenv.mkDerivation rec {
  name = "ismrmrd-" + ver;

  src = fetchFromGitHub {
    owner = "ismrmrd";
    repo = "ismrmrd";
    rev = ver;
    inherit sha256;
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake boost fftw hdf5-cpp ];

  meta = {
    description = "ISMRM Raw Data Format (ISMRMRD)";
    homepage = https://ismrmrd.github.io/;
  };
}
