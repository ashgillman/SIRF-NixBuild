{ stdenv
, buildPythonPackage
, fetchPypi
, tqdm
, requests
, numpy
, scikitimage
, matplotlib
# , nose
}:

buildPythonPackage rec {
  version = "1.6.2";
  pname = "brainweb";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bsfnyp7n8cc6jxqabg0w5jadryf83rk8l0ksii6cchrsl45mjng";
  };

  propagatedBuildInputs = [ 
    tqdm
    requests
    numpy
    scikitimage
    matplotlib
  ];

#   checkInputs = [
#     nose
#   ];

}