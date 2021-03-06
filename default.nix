{ pkgs ? import <nixpkgs> {} }:

with pkgs;
rec {
  pythonPackages = python3Packages;

  niftyreg = callPackage ./pkgs/niftyreg {};  # default nixpkgs is old
  ismrmrd = callPackage ./pkgs/ismrmrd {};
  gadgetron = callPackage ./pkgs/gadgetron {
    inherit pythonPackages;
    inherit dcmtk fftw fftwFloat ismrmrd;
    liblapack = pkgs.liblapackWithoutAtlas;
    #boost = boost164;
  };
  petmr-rd-tools = callPackage ./pkgs/petmr-rd-tools {};

  cil = callPackage ./pkgs/cil {};
  ccpiReg = callPackage ./pkgs/ccpi-regularisation {
    inherit (pythonPackages) setuptools cython numpy;
  };

  tomophantom = callPackage ./pkgs/tomophantom {
    inherit (pythonPackages) cython numpy;
  };

  brainweb = callPackage ./pkgs/brainweb {
    inherit (pythonPackages)
      fetchPypi
      buildPythonPackage
      tqdm
      requests
      numpy
      scikitimage
      matplotlib;
  };

  stir = callPackage ./pkgs/stir { inherit (pythonPackages) python numpy; };
  sirf = callPackage ./pkgs/sirf {
    inherit pythonPackages fftw fftwFloat niftyreg ismrmrd gadgetron petmr-rd-tools stir;
  };
}
