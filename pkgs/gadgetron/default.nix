{ stdenv
, fetchurl
, fetchFromGitHub
, cmake
, pkgconfig
, ace
, armadillo
# , blas
, boost
# , cudatoolkit
, dcmtk
, fftw
, fftwFloat
, git
, gfortran
, gtest
, hdf5-cpp
, ismrmrd
, liblapack
, openblas
# , plplot
, pythonPackages
}:

let
  ver = "v3.15.0";
  sha256 = "18c1qdx0krs83ij95398nzdylv54fw61a7dyyybv82lgaifnnyn0";

in stdenv.mkDerivation rec {
  name = "gadgetron-" + ver;

  src = fetchFromGitHub {
    owner = "gadgetron";
    repo = "gadgetron";
    rev = ver;
    inherit sha256;
  };

  cmakeFlags = [
    # "-DPLPLOT_PATH=${plplot}/include"
    "-DBLAS_openblas_LIBRARY=${openblas}/lib/libopenblas.so"
  ];
    # "-DBUILD_PYTHON=ON"
  # cmakeFlags="-DPYTHON_DEST=$out/${pythonPackages.python.sitePackages} $cmakeFlags"

  pythonPath = "";  # Makes python.buildEnv include libraries

  enableParallelBuilding = true;

  buildInputs =
    [ cmake pkgconfig ace armadillo boost dcmtk #openblas cudatoolkit
      fftw.dev fftwFloat.dev git gfortran gtest hdf5-cpp liblapack
    ];
  propagatedBuildInputs =
    [ ismrmrd ]
    ++ ( with pythonPackages; [ python boost numpy ] );

  meta = {
    description = "The Gadgetron is an open source framework for medical image reconstruction.";
    homepage = http://gadgetron.github.io/;
  };
}
