{
  deno,
  nodejs,
  cacert,
  stdenv,
  system,
  inputs,
  ...
}:
stdenv.mkDerivation {
  pname = "carbon-colours-gitea";
  version = "1.0.2";
  src = inputs.self;

  nativeBuildInputs = [
    deno
    nodejs
    cacert
  ];

  buildPhase = ''
    export HOME=$TMPDIR
    export DENO_DIR=$TMPDIR/deno
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    export NODE_EXTRA_CA_CERTS=${cacert}/etc/ssl/certs/ca-bundle.crt

    deno cache --node-modules-dir build.ts || true
    mkdir -p node_modules/@catppuccin
    rm -rf node_modules/@catppuccin/palette
    cp -r ${inputs.palette.packages.${system}.npm} node_modules/@catppuccin/palette

    deno task build
  '';

  installPhase = ''
    cp -r dist/ $out
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "sha256-FD61eyQVR/98kiqfs1BuGX0YmF13CmYs5dmKXTQ9/ZE=";
}
