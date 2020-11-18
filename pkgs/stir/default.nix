{ stdenv
, fetchFromGitHub
, cmake , boost , itk , swig
, buildPython ? true, python, numpy
}:

let
  rev = "release_4";
  sha256 = "1siplks8ciapzbp3jvq8v28gwaz9frhlpzip7crawjzk5sbw46ix";
in stdenv.mkDerivation rec {
  name = "stir-${rev}";

  src = fetchFromGitHub {
    owner = "UCL";
    repo = "STIR";
    inherit rev sha256;
  };

  buildInputs = [ boost cmake itk /*openmpi*/ ];
  propagatedBuildInputs = [ swig ]
    ++ stdenv.lib.optional buildPython [ python numpy ];

  # This is a hackaround because STIR requires source available at runtime.
  setSourceRoot = ''
    actualSourceRoot=;
    for i in *;
    do
        if [ -d "$i" ]; then
            case $dirsBefore in
                *\ $i\ *)

                ;;
                *)
                    if [ -n "$actualSourceRoot" ]; then
                        echo "unpacker produced multiple directories";
                        exit 1;
                    fi;
                    actualSourceRoot="$i"
                ;;
            esac;
        fi;
    done;

    # "Install" location for source
    sourceRoot=$prefix/src
    mkdir -p $sourceRoot
    # Put the actual source there
    cp -r $actualSourceRoot -T $sourceRoot
  '';
  cmakeFlags = [
    #"-DBUILD_SHARED_LIBS=ON"
    #"-DBUILD_SWIG_PYTHON=ON"
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

    # Remove the temporary build
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
