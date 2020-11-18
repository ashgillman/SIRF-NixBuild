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
  stir = callPackage ./pkgs/stir { inherit (pythonPackages) python numpy; };

  sirf = callPackage ./pkgs/sirf {
    inherit pythonPackages fftw fftwFloat niftyreg ismrmrd gadgetron petmr-rd-tools stir;
  };
}
