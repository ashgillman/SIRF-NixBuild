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
  rev = "b6191eaaa72ccca6c6a5fe4c0fa3319694f512ab";  # what SuperBuild uses
  sha256 = "0ql4j0f1ah02yrwswhj17sl57fff29pybhkxn5h4ai2f2jcq2zsv";

in stdenv.mkDerivation rec {
  name = "gadgetron";

  src = fetchFromGitHub {
    owner = "gadgetron";
    repo = "gadgetron";
    inherit rev;
    inherit sha256;
  };

  cmakeFlags = [
    "-DBLAS_openblas_LIBRARY=${openblas}/lib/libopenblas.so"
    "-DBUILD_PYTHON_SUPPORT=OFF"
    "-DBUILD_MATLAB_SUPPORT=OFF"
  ];
    # "-DBUILD_PYTHON=ON"
  postInstall = ''
    cp $prefix/share/gadgetron/config/gadgetron.xml.example \
       $prefix/share/gadgetron/config/gadgetron.xml
  '';

  # pythonPath = "";  # Makes python.buildEnv include libraries

  enableParallelBuilding = true;

  buildInputs =
    [ cmake pkgconfig ace armadillo boost dcmtk #openblas cudatoolkit
      fftw fftwFloat
      fftw.dev fftwFloat.dev git gfortran gtest hdf5-cpp liblapack
    ]
    ++ ( with pythonPackages; [ python boost numpy ] );
  propagatedBuildInputs =
    [ ismrmrd ];
    # ++ ( with pythonPackages; [ python boost numpy ] );

  meta = {
    description = "The Gadgetron is an open source framework for medical image reconstruction.";
    homepage = http://gadgetron.github.io/;
  };
}
