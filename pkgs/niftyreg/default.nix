{ stdenv
, fetchurl
, fetchFromGitHub
, cmake
, libpng12
, zlib
}:

let
  ver = "1.5.68";
  rev = "99d584e2b8ea0bffe7e65e40c8dc818751782d92";
  sha256 = "1b3475vp78m661wc96m9y3lfa7xxwmvqx23kbvd71rnb00bh769v";

in stdenv.mkDerivation rec {
  name = "niftyreg-" + ver;

  src = fetchFromGitHub {
    owner = "KCL-BMEIS";
    repo = "niftyreg";
    inherit rev sha256;
  };

  patches = [ ./gcc9-fix.patch ];

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
