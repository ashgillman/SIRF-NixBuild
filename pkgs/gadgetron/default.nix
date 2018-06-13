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
  # ver = "v3.15.0";
  ver = "20180613";
  sha256 = "01p45437h2i3k0chzcg5c8bh3s0m2w0jjxaxzzfyfrk3rv757qg3";

in stdenv.mkDerivation rec {
  name = "gadgetron-" + ver;

  src = fetchFromGitHub {
    owner = "gadgetron";
    repo = "gadgetron";
    rev = "8c094c6";
    # rev = ver;
    inherit sha256;
  };

  cmakeFlags = [
    # "-DPLPLOT_PATH=${plplot}/include"
    "-DBLAS_openblas_LIBRARY=${openblas}/lib/libopenblas.so"
    "-DBUILD_PYTHON_SUPPORT=OFF"
    "-DBUILD_MATLAB_SUPPORT=OFF"
  ];
    # "-DBUILD_PYTHON=ON"
  # cmakeFlags="-DPYTHON_DEST=$out/${pythonPackages.python.sitePackages} $cmakeFlags"
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
