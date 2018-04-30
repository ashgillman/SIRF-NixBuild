{ stdenv
, fetchFromGitHub
, cmake
, boost
, fftw
, fftwFloat
, hdf5
, itk
, swig
, gadgetron
, ismrmrd
, pythonPackages
, stir
}:

stdenv.mkDerivation rec {
  name = "sirf-v1.0.1-pre";

  src = fetchFromGitHub {
    owner = "CCPPETMR";
    repo = "SIRF";
    rev = "4a0950a";  # master: 20180428
    sha256 = "07yxyq2bn9hxh64wx68l04xkkwdnnkfd6svl2mvyxaq2p8sfdj51";
    fetchSubmodules = true;
  };

  # patches = [ ./FindFFTW3.patch ];
  patches = [ ./find_fftwf.patch ];
  cmakeFlags = [
    "-DBUILD_PYTHON=ON"
    "-DSTIR_DIR=${stir}/lib/cmake"
    "-DFFTW3f_DIR=${fftwFloat.dev}/lib/cmake/fftw3"
  ];
  preConfigure = ''
    cmakeFlags="-DPYTHON_DEST=$out/${pythonPackages.python.sitePackages} $cmakeFlags"
  '';

  pythonPath = ""; # Makes python.buildEnv include libraries

  enableParallelBuilding = true;

  buildInputs = [ boost cmake itk fftwFloat hdf5 swig ];
  # buildInputs = [ boost cmake itk fftw fftwFloat hdf5 swig ];
  propagatedBuildInputs = [ gadgetron ismrmrd stir ]
    ++ ( with pythonPackages; [
      python
      numpy scipy matplotlib
      docopt h5py /*libxml2*/ psutil nose
    ] );

  meta = {
    # description = "Software for Tomographic Image Reconstruction";
    # homepage = http://stir.sourceforge.net;
  };
}
