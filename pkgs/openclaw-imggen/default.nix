{
  lib,
  stdenvNoCC,
  makeWrapper,
  bash,
  curl,
  jq,
  coreutils,
  gnused,
}:

stdenvNoCC.mkDerivation {
  pname = "openclaw-imggen";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 imggen.sh "$out/bin/imggen"

    wrapProgram "$out/bin/imggen" \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          curl
          jq
          coreutils
          gnused
        ]
      }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Lightweight image generation CLI for OpenClaw using the OpenAI Images API";
    license = licenses.mit;
    platforms = platforms.all;
    mainProgram = "imggen";
  };
}
