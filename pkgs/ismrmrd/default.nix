{ stdenv
, fetchFromGitHub
, cmake
, boost
, fftw
, hdf5-cpp
}:

let
  ver = "20180525";
  rev = "1c8b53c";
  sha256 = "1chcr238gjjhaz46q177kra328d3z92grlz45n3n75gpl1kfhxd5";

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
