{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  gobject-introspection,
  setuptools,
  proton-core,
  proton-vpn-network-manager,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "proton-vpn-network-manager-openvpn";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProtonVPN";
    repo = "python-proton-vpn-network-manager-openvpn";
    rev = "refs/tags/v${version}";
    hash = "sha256-eDBcpuz37crfAFX6oysB4FCkSmVLyfLJ0R2L0cZgjRo=";
  };

  nativeBuildInputs = [
    # Solves Namespace NM not available
    gobject-introspection
    setuptools
  ];

  propagatedBuildInputs = [
    proton-core
    proton-vpn-network-manager
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace-fail "--cov=proton.vpn.backend.linux.networkmanager.protocol.openvpn --cov-report html --cov-report term" ""
  '';

  pythonImportsCheck = [ "proton.vpn.backend.linux.networkmanager.protocol" ];

  nativeCheckInputs = [ pytestCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Adds support for the OpenVPN protocol using NetworkManager";
    homepage = "https://github.com/ProtonVPN/python-proton-vpn-network-manager-openvpn";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sebtm ];
  };
}
