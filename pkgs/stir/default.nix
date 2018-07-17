{ stdenv
, fetchFromGitHub
, cmake , boost , itk , swig
, buildPython ? true, python, numpy
}:

stdenv.mkDerivation rec {
  name = "stir-4.0-pre";

  src = fetchFromGitHub {
    owner = "UCL";
    repo = "STIR";
    rev = "4e0a2e8";  # master: 20180630
    sha256 = "1cpq1msypby7cvxfn4pq2ii46wx36zskjrhxq7psbqyap620g3pi";
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
