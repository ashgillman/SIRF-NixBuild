{ stdenv
, fetchFromGitHub
, cmake , boost , itk , swig
, buildPython ? true, python, numpy
}:

stdenv.mkDerivation rec {
  name = "stir-3.1-pre";

  src = fetchFromGitHub {
    owner = "UCL";
    repo = "STIR";
    rev = "6108fcb";  # master: 20180424
    sha256 = "0qiriaxhcqvw32nb6mxgicw3cvikw16w9vfl1r47zffa4vyp1gnc";
  };

  buildInputs = [ boost cmake itk /*openmpi*/ ];
  propagatedBuildInputs = [ swig ]
    ++ stdenv.lib.optional buildPython [ python numpy ];

  # This is a hackaround because STIR requires source available at runtime..
  setSourceRoot = ''
    sourceRoot=$prefix/src
    mkdir -p $sourceRoot
    cp -r STIR-*-src/* $sourceRoot
  '';
  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_SWIG_PYTHON=ON"
    "-DGRAPHICS=PGM"
    "-DSTIR_MPI=OFF"
    "-DSTIR_OPENMP=${if stdenv.isDarwin then "OFF" else "ON"}"
  ];
  preConfigure = stdenv.lib.optionalString buildPython ''
    cmakeFlags="-DPYTHON_DEST=$out/${python.sitePackages} $cmakeFlags"
  '';
  postInstall = ''
    # add scripts to bin
    find $src/scripts -type f ! -path "*maintenance*" -name "*.sh"  -exec cp -fn {} $out/bin \;
    find $src/scripts -type f ! -path "*maintenance*" ! -name "*.*" -exec cp -fn {} $out/bin \;
    rm -r $sourceRoot/build
  '';

  pythonPath = "";  # Makes python.buildEnv include libraries
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Software for Tomographic Image Reconstruction";
    homepage = http://stir.sourceforge.net;
    license = with licenses; [ lgpl21 gpl2 free ];  # free = custom PARAPET license
  };
}
