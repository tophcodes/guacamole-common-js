# Builds the npm package directory from an Apache Guacamole release. The
# bundle mirrors upstream's own `all.js`: the license header followed by every
# module in file name order, plus one export line per module format.
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  nix-update-script,
  esbuild,
  jq,
  nodejs,
}:
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "guacamole-common-js";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "apache";
    repo = "guacamole-client";
    tag = finalAttrs.version;
    hash = "sha256-0gKPgxrf75+YeO11IWADiMfSdJ8gJ/5RDZ9a/ApeEQM=";
  };

  nativeBuildInputs = [esbuild jq];

  buildPhase = ''
    runHook preBuild

    webapp=guacamole-common-js/src/main/webapp
    cat $webapp/common/license.js $webapp/modules/*.js > bundle.js

    mkdir -p dist/esm dist/cjs
    { cat bundle.js; echo 'export default Guacamole;'; } > dist/esm/guacamole-common.js
    { cat bundle.js; echo 'module.exports = Guacamole;'; } > dist/cjs/guacamole-common.js
    echo '{"type": "commonjs"}' > dist/cjs/package.json

    for format in esm cjs; do
      esbuild --minify --legal-comments=inline --log-level=warning \
        dist/$format/guacamole-common.js --outfile=dist/$format/guacamole-common.min.js
    done

    jq --arg version "${finalAttrs.version}" '{name, version: $version} + .' \
      ${./package.json} > package.json

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r dist package.json $out/
    cp ${./README.md} $out/README.md
    cp ${./LICENSE} $out/LICENSE
    cp ${./NOTICE} $out/NOTICE
    runHook postInstall
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [nodejs];
  installCheckPhase = ''
    runHook preInstallCheck
    node ${./test/smoke.mjs} $out
    runHook postInstallCheck
  '';

  # Stable releases only; upstream tags its release candidates 1.6.0-RC1 and so on.
  passthru.updateScript = nix-update-script {
    extraArgs = ["--version-regex" "^(\\d+\\.\\d+\\.\\d+)$"];
  };

  meta = {
    description = "The Apache Guacamole JavaScript client, packaged for npm";
    homepage = "https://github.com/tophcodes/guacamole-common-js";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
  };
})
