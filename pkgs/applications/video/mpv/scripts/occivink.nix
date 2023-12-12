{ lib
, fetchFromGitHub
, unstableGitUpdater
, buildLua
}:

let
  camelToKebab = let
    inherit (lib.strings) match stringAsChars toLower;
    isUpper = match "[A-Z]";
  in stringAsChars (c: if isUpper c != null then "-${toLower c}" else c);

  mkScript = name: args:
    let self = rec {
      pname = camelToKebab name;
      version = "unstable-2022-10-02";
      src = fetchFromGitHub {
        owner = "occivink";
        repo = "mpv-scripts";
        rev = "af360f332897dda907644480f785336bc93facf1";
        hash = "sha256-KdCrUkJpbxxqmyUHksVVc8KdMn8ivJeUA2eerFZfEE8=";
      };
      passthru.updateScript = unstableGitUpdater {};

      scriptPath = "scripts/${pname}.lua";

      meta = with lib; {
        homepage = "https://github.com/occivink/mpv-scripts";
        license = licenses.unlicense;
        maintainers = with maintainers; [ nicoo ];
      };

      # Sadly needed to make `common-updaters` work here
      pos = builtins.unsafeGetAttrPos "version" self;
    };
    in buildLua (lib.attrsets.recursiveUpdate self args);

in
lib.mapAttrs (name: lib.makeOverridable (mkScript name)) {

  # Usage: `pkgs.mpv.override { scripts = [ pkgs.mpvScripts.seekTo ]; }`
  seekTo = {
    meta.description = "Mpv script for seeking to a specific position";
    outputHash = "sha256-3RlbtUivmeoR9TZ6rABiZSd5jd2lFv/8p/4irHMLshs=";
  };

  blacklistExtensions = {
    meta.description = "Automatically remove playlist entries based on their extension.";
    outputHash = "sha256-qw9lz8ofmvvh23F9aWLxiU4YofY+YflRETu+nxMhvVE=";
  };
}
