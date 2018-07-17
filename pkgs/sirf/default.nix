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
, petmr-rd-tools
, pythonPackages
, stir
}:

stdenv.mkDerivation rec {
  name = "sirf-v1.1.2-pre";

  src = fetchFromGitHub {
    owner = "CCPPETMR";
    repo = "SIRF";
    rev = "163c3a6";  # master: 20180623
    sha256 = "1cz0j8lg93z29a4smswmpxbmjp6n9hl95idmr09y1c99fyz0pad3";
    fetchSubmodules = true;
  };

  patches = [ ./find_fftwf.patch ];
  cmakeFlags = [
    "-DBUILD_PYTHON=ON"
    "-DSTIR_DIR=${stir}/lib/cmake"
    "-DFFTW3f_DIR=${fftwFloat.dev}/lib/cmake/fftw3"
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

  buildInputs = [ boost cmake itk fftwFloat hdf5 swig ];
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
