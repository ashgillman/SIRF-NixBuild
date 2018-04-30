{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "glog-${version}";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "Google";
    repo = "glog";
    rev = "v${version}";
    sha256 = "12v7j6xy0ghya6a0f6ciy4fnbdc486vml2g07j9zm8y5xc6vx3pq";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    homepage = http://code.google.com/p/google-glog/;
    license = licenses.bsd3;
    description = "Library for application-level logging";
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
