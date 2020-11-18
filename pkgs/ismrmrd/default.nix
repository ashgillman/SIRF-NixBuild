{ stdenv
, fetchFromGitHub
, cmake
, boost
, fftw
, hdf5-cpp
}:

let
  ver = "20180525";
  rev = "v1.4.1";
  sha256 = "1291k3cd2wvcnb8f4x8vzv9kv3bcjd9wl1654i3cj2hv8vwkda0c";

in stdenv.mkDerivation rec {
  name = "ismrmrd-" + ver;

  src = fetchFromGitHub {
    owner = "ismrmrd";
    repo = "ismrmrd";
    inherit sha256 rev;
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake boost fftw hdf5-cpp ];

  meta = {
    description = "ISMRM Raw Data Format (ISMRMRD)";
    homepage = https://ismrmrd.github.io/;
  };
}
