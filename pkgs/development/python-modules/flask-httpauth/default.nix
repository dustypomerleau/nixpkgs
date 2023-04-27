{ lib
, python
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, setuptools
, flask
 }:

buildPythonPackage rec {
  pname = "flask-httpauth";
  version = "4.8.0";
  format = "pyproject";

  disabled = python.pythonOlder "3";

  src = fetchPypi {
    pname = "Flask-HTTPAuth";
    version = version;
    hash = "sha256-ZlaKBbxzlCxl8eIgGudGKVgW3ACe3YS0gsRMdY11CXo=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    flask
  ];

  pythonImportsCheck = [
    "flask_httpauth"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ] ++ flask.optional-dependencies.async;

  meta = with lib; {
    description = "Extension that provides HTTP authentication for Flask routes";
    homepage = "https://github.com/miguelgrinberg/Flask-HTTPAuth";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
