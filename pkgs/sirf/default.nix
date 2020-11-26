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

let
  rev = "v2.2.0";
  sha256 = "0ffdim0anq298nlglys4w2w52721rj96mgk251cs294c5i0dxp6m";
in stdenv.mkDerivation rec {
  name = "sirf-${rev}";

  src = fetchFromGitHub {
    owner = "CCPPETMR";
    repo = "SIRF";
    fetchSubmodules = true;
    inherit rev sha256;
  };

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
