{ pkgs ? import <nixpkgs> {} }:

with pkgs;
with import ./. { inherit pkgs; };


let
  # need to run `source build`
  buildScript = writeScriptBin "build" ''
    [ $(basename $PWD) == build ] || $configurePhase \
    && buildPhase \
    && installPhase \
    && fixupPhase
  '';

in sirf.overrideDerivation (
  oldAttrs: {
    buildInputs = oldAttrs.buildInputs ++ [
      cmakeCurses buildScript
      python3.pkgs.ipython python3.pkgs.nibabel
    ];
    cmakeBuildType = "Debug";
    preConfigure = ''
      export out=$PWD/install
      export prefix=$PWD/install
    '' + oldAttrs.preConfigure;
    shellHook = ''
      export PYTHONPATH="$PYTHONPATH:$PWD/install/python"
    '';
  }
)
