{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  proton-core,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "proton-vpn-logger";
  version = "0.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-logger";
    rev = "refs/tags/v${version}";
    hash = "sha256-/LfMjyTs/EusgnKEQugsdJzqDZBvaAhbsTUVLDCRw0I=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ proton-core ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov=proton/vpn/logging/ --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton.vpn.logging" ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    # Needed for Permission denied: '/homeless-shelter'
    export HOME=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "General purpose logging package for the entire ProtonVPN Linux client";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-logger";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
