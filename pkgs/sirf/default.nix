{ stdenv
, fetchFromGitHub
, cmake
, boost
, fftw
, itk
, swig
, gadgetron
, ismrmrd
, pythonPackages
, stir
}:

let
  nixpkgsVer = builtins.readFile <nixpkgs/.version>;

  ver = "v0.9.0";
  sha256 = "1b2pzad0nih885vhinwxw3769c0q25vh9wl42k10yz54czi88vqf";

in stdenv.mkDerivation rec {
  name = "sirf-" + ver;

  src = fetchFromGitHub {
    owner = "CCPPETMR";
    repo = "SIRF";
    rev = ver;
    inherit sha256;
  };

  CMAKE_MODULE_PATH="${gadgetron}/share/gadgetron/cmake";
  cmakeFlags = [
    "-DBUILD_PYTHON=ON"
    "-DSTIR_DIR=${stir}/lib/cmake"
    "-DCMAKE_MODULE_PATH=${gadgetron}/share/gadgetron/cmake"
  ];
  preConfigure = ''
    #rm -rf build
    cmakeFlags="-DPYTHON_DEST=$out/${pythonPackages.python.sitePackages} $cmakeFlags"
  '';

  pythonPath = ""; # Makes python.buildEnv include libraries

  enableParallelBuilding = true;

  buildInputs = [ boost cmake itk ];
  propagatedBuildInputs = [ gadgetron ismrmrd swig swig ]
    ++ ( with pythonPackages; [ python numpy ] );

  meta = {
    # description = "Software for Tomographic Image Reconstruction";
    # homepage = http://stir.sourceforge.net;
  };
}
