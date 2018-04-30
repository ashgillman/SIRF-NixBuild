{ pkgs ? import <nixpkgs> {} }:

with pkgs;
with import ./. { inherit pkgs; };

let
  boostAll = symlinkJoin {
    name ="boost-all";
    paths = [ boost.out boost.dev ];
  };

in stdenv.mkDerivation {
  name = "SIRF-build";
  buildInputs = [
    sirf
    # cmakeWithGui
    # ace boostAll liblapack openblas armadillo gtest hdf5 itk swig glog
    # dcmtk /*plplot*/ fftw ismrmrd gadgetron
  ];
  # propagatedBuildInputs = with pythonPackages; [
  #   python numpy scipy matplotlib docopt
  # ];
  SIRF_PATH=sirf.src;
  shellHook = ''
    export PYTHONPATH=${sirf}/python:$PYTHONPATH
  '';
}
