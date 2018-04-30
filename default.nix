{ pkgs ? import <nixpkgs> {} }:

with pkgs;
rec {
  pythonPackages = python3Packages;
  glog = callPackage ./pkgs/glog {};
  dcmtk = callPackage ./pkgs/dcmtk {};
  # plplot = callPackage ./pkgs/plplot {};
  fftw = callPackage ./pkgs/fftw { precision = "double"; };
  fftwFloat = callPackage ./pkgs/fftw { precision = "single"; };
  ismrmrd = callPackage ./pkgs/ismrmrd {};
  # gadgetron = callPackage ./pkgs/gadgetron { inherit dcmtk plplot pythonPackages ismrmrd; };
  gadgetron = callPackage ./pkgs/gadgetron { inherit dcmtk fftw fftwFloat /*plplot*/ ismrmrd; }; # python 3 not yet supported
  stir = callPackage ./pkgs/stir { inherit (pythonPackages) python numpy; };
  # sirf = callPackage ./pkgs/sirf { inherit pythonPackages fftw ismrmrd gadgetron stir; };
  sirf = callPackage ./pkgs/sirf { inherit pythonPackages fftw fftwFloat ismrmrd gadgetron stir; };
}
