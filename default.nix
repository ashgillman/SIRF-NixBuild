{ pkgs ? import <nixpkgs> {} }:

with pkgs;
rec {
  pythonPackages = python3Packages;

  dcmtk = callPackage ./pkgs/dcmtk {};
  fftw = callPackage ./pkgs/fftw { precision = "double"; };
  fftwFloat = callPackage ./pkgs/fftw { precision = "single"; };
  glog = callPackage ./pkgs/glog {};
  # plplot = callPackage ./pkgs/plplot {};

  niftyreg = callPackage ./pkgs/niftyreg {};
  ismrmrd = callPackage ./pkgs/ismrmrd {};
  # gadgetron = callPackage ./pkgs/gadgetron { inherit dcmtk plplot pythonPackages ismrmrd; };
  gadgetron = callPackage ./pkgs/gadgetron {
    inherit pythonPackages;
    inherit dcmtk fftw fftwFloat /*plplot*/ ismrmrd;
    boost = boost164;
  }; # python 3 not yet supported
  petmr-rd-tools = callPackage ./pkgs/petmr-rd-tools {};
  stir = callPackage ./pkgs/stir { inherit (pythonPackages) python numpy; };

  # sirf = callPackage ./pkgs/sirf { inherit pythonPackages fftw ismrmrd gadgetron stir; };
  sirf = callPackage ./pkgs/sirf {
    inherit pythonPackages fftw fftwFloat niftyreg ismrmrd gadgetron petmr-rd-tools stir;
  };
}
