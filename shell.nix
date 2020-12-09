{ pkgs ? import <nixpkgs> {} }:

with pkgs;
with import ./. { inherit pkgs; };

let
  # boostAll = symlinkJoin {
  #   name ="boost-all";
  #   paths = [ boost.out boost.dev ];
  # };

in stdenv.mkDerivation {
  name = "SIRF-build";
  # buildInputs = [
    # cmakeWithGui
    # ace boostAll liblapack openblas armadillo gtest hdf5 itk swig glog
    # dcmtk /*plplot*/ fftw ismrmrd gadgetron
  # ];
  propagatedBuildInputs = with python3Packages; [
    sirf
    cil ccpiReg
    python ipython numpy scipy matplotlib docopt
  ];
  SIRF_PATH=sirf.src;
  MPLBACKEND="Qt4Agg";
  shellHook = ''
    export PYTHONPATH=${sirf}/python:$PYTHONPATH
    export LD_LIBRARY_PATH=${cil}/lib:$LD_LIBRARY_PATH  # this is a hack, shouldn't be necessary...
  '';
}
