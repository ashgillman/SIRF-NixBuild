{ stdenv
, fetchFromGitHub
, cmake
, boost
, fftw
, fftwFloat
, hdf5
, itk
, swig
, niftyreg
, gadgetron
, ismrmrd
, petmr-rd-tools
, pythonPackages
, stir
}:

stdenv.mkDerivation rec {
  name = "sirf-v1.1.2-pre";

  src = fetchFromGitHub {
    owner = "CCPPETMR";
    repo = "SIRF";
    rev = "v2.2.0";
    sha256 = "0ffdim0anq298nlglys4w2w52721rj96mgk251cs294c5i0dxp6m";
    fetchSubmodules = true;
  };

  #patches = [ ./find_fftwf.patch ];
  cmakeFlags = [
    "-DBUILD_PYTHON=ON"
    "-DDOWNLOAD_ZENODO_TEST_DATA=OFF"
    "-DSTIR_DIR=${stir}/lib/cmake"
    "-DFFTW3f_DIR=${fftwFloat.dev}/lib/cmake/fftw3"
    "-DNIFTYREG_Source_DIR=${niftyreg}/src"
    "-DNIFTYREG_Binary_DIR=${niftyreg}/bin"
    "-DNIFTYREG_DIR=${niftyreg}"
  ];
  preConfigure = ''
    cmakeFlags="-DPYTHON_DEST=$out/${pythonPackages.python.sitePackages} $cmakeFlags"
  '';
  postInstall = ''
    mkdir -p $(dirname $out/${pythonPackages.python.sitePackages})
    mv $out/python $out/${pythonPackages.python.sitePackages}
  '';

  pythonPath = ""; # Makes python.buildEnv include libraries

  enableParallelBuilding = true;

  buildInputs = [ boost cmake itk fftwFloat hdf5 swig niftyreg ];
  # buildInputs = [ boost cmake itk fftw fftwFloat hdf5 swig ];
  propagatedBuildInputs = [ gadgetron ismrmrd petmr-rd-tools stir ]
    ++ ( with pythonPackages; [
      python
      numpy scipy (matplotlib.override { enableQt = true; })
      docopt h5py /*libxml2*/ psutil nose
    ] );

  meta = {
    # description = "Software for Tomographic Image Reconstruction";
    # homepage = http://stir.sourceforge.net;
  };
}
