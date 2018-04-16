with import <nixpkgs> {};

rec {
  pythonPackages = python3Packages;
  dcmtk = callPackage ./pkgs/dcmtk {};
  plplot = callPackage ./pkgs/plplot {};
  ismrmrd = callPackage ./pkgs/ismrmrd {};
  # gadgetron = callPackage ./pkgs/gadgetron { inherit dcmtk plplot pythonPackages ismrmrd; };
  gadgetron = callPackage ./pkgs/gadgetron { inherit dcmtk /*plplot*/ ismrmrd; }; # python 3 not yet supported
  stir = callPackage ./pkgs/stir { inherit (pythonPackages) python numpy; };
  sirf = callPackage ./pkgs/sirf { inherit pythonPackages ismrmrd gadgetron stir; };
}
