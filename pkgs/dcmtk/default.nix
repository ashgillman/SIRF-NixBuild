{ stdenv
, fetchgit
, libpng12
, libtiff
, zlib
}:

let
  ver = "3.6.0";
  rev = "refs/tags/DCMTK-3.6.1_20170228";
  sha256 = "0an22yr1arwsk00s1136p52zzpifj39zmphd8fg1nrnnv2nzf97i";

in stdenv.mkDerivation rec {
  name = "dcmtk-" + ver;

  src = fetchgit {
    url = git://git.dcmtk.org/dcmtk.git;
    inherit rev sha256;
  };

  buildInputs = [ libpng12 libtiff zlib ];

  installTargets = "install-lib";

  enableParallelBuilding = true;

  meta = {
    description = "Cross-platform plotting";
    homepage = http://plplot.sourceforge.net/;
  };
}
