{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gobject-introspection,
  setuptools,
  networkmanager,
  proton-vpn-api-core,
  proton-vpn-killswitch,
  proton-vpn-logger,
  pycairo,
  pygobject3,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "proton-vpn-killswitch-network-manager";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-killswitch-network-manager";
    rev = "refs/tags/v${version}";
    hash = "sha256-KEwltKs/scTPugELfQVDt+JkXyjdxUhwRlfzyAzucJA=";
  };

  nativeBuildInputs = [
    # Solves ImportError: cannot import name NM, introspection typelib not found
    gobject-introspection
    setuptools
  ];

  propagatedBuildInputs = [
    # Needed here for the NM namespace
    networkmanager
    proton-vpn-api-core
    proton-vpn-killswitch
    proton-vpn-logger
    pycairo
    pygobject3
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov=proton.vpn.killswitch.backend.linux.networkmanager --cov-report=html --cov-report=term" ""
  '';

  pythonImportsCheck = [ "proton.vpn.killswitch.backend.linux.networkmanager" ];

  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Implementation of the proton-vpn-killswitch interface using Network Manager";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-killswitch-network-manager";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
