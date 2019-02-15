{ stdenv
, fetchurl
, fetchFromGitHub
, cmake
, libpng12
, zlib
}:

let
  ver = "1.5.59";
  rev = "f673b7837c0824f55dedb1534b32b55bf68a2823";
  sha256 = "1pjb5iwxspp405kwb86vbyy30gxn426nnxi76s8h1ny5wmcwsh2f";

in stdenv.mkDerivation rec {
  name = "niftyreg-" + ver;

  src = fetchFromGitHub {
    owner = "KCL-BMEIS";
    repo = "niftyreg";
    inherit rev sha256;
  };

  # This is a hackaround because SIRF requires niftyreg source available at build.
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

  # source is in a subfolder.
  # don't need with the above "hackaround"
  # preConfigure = "cd nifty_reg";

  enableParallelBuilding = true;

  buildInputs = [ cmake libpng12 zlib ];

  meta = {
    description = "Tools to perform rigid, affine and non-linear registration of nifti or analyse images";
    homepage = https://github.com/KCL-BMEIS/niftyreg;
  };
}