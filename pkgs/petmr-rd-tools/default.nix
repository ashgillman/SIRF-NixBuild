{ stdenv
, fetchFromGitHub
, cmake
, boost
, itk
, glog
}:

stdenv.mkDerivation rec {
  name = "petmr-rd-tools-master";

  src = fetchFromGitHub {
    owner = "UCL";
    repo = "petmr-rd-tools";
    rev = "v2.0.1";
    sha256 = "0fc77i6li7bhrymmkg678nd3nhb7j1nbqxvmw6qg98xkg5xlsgn2";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake boost itk glog ];

  meta = {
    description = "Command line tools for PET-MR (pre)-processing";
    homepage = https://github.com/UCL/petmr-rd-tools;
  };
}
