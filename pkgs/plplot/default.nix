{ stdenv
, fetchurl
, cmake
, pkgconfig
, freetype
, libtool
, qhull
}:

let
  ver = "5.12.0";
  sha256 = "1kjjsfk60wfa3wh87pnslm20xk149alg4gjc7ncijkhfz1gdmicd";

in stdenv.mkDerivation rec {
  name = "plplot-" + ver;

  src = fetchurl {
    url = "mirror://sourceforge/plplot/${name}.tar.gz";
    inherit sha256;
  };

  preBuild = ''
    export LD_LIBRARY_PATH="$PWD/lib/csa:$PWD/lib/nistcd:$PWD/lib/nn:$PWD/lib/qsastime"
  '';
  enableParallelBuilding = true;

  buildInputs = [ cmake pkgconfig freetype libtool qhull ];

  meta = {
    description = "Cross-platform plotting";
    homepage = http://plplot.sourceforge.net/;
  };
}
