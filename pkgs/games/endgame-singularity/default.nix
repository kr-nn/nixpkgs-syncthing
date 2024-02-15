{ lib
, fetchurl
, fetchFromGitHub
, unzip
, python3
, enableDefaultMusicPack ? true
}:

let
  pname = "endgame-singularity";
  version = "1.00";

  main_src = fetchFromGitHub {
    owner = "singularity";
    repo = "singularity";
    rev = "v${version}";
    sha256 = "0ndrnxwii8lag6vrjpwpf5n36hhv223bb46d431l9gsigbizv0hl";
  };

  music_src = fetchurl {
    url = "http://www.emhsoft.com/singularity/endgame-singularity-music-007.zip";
    sha256 = "0vf2qaf66jh56728pq1zbnw50yckjz6pf6c6qw6dl7vk60kkqnpb";
  };
in

python3.pkgs.buildPythonApplication rec {
  inherit pname version;

  srcs = [ main_src ] ++ lib.optional enableDefaultMusicPack music_src;
  sourceRoot = main_src.name;

  nativeBuildInputs = [ unzip ]; # The music is zipped
  propagatedBuildInputs = with python3.pkgs; [ pygame numpy polib ];

  # Add the music
  postInstall = lib.optionalString enableDefaultMusicPack ''
    cp -R "../endgame-singularity-music-007" \
          "$(echo $out/lib/python*/site-packages/singularity)/music"
          # ↑ we cannot glob on [...]/music, it doesn't exist yet
  '';

  meta = {
    homepage = "http://www.emhsoft.com/singularity/";
    description = "A simulation game about strong AI";
    longDescription = ''
      A simulation of a true AI. Go from computer to computer, pursued by the
      entire world. Keep hidden, and you might have a chance
    '';
    # License details are in LICENSE.txt
    license = with lib.licenses; [
      gpl2Plus # most of the code, some translations
      mit # recursive_fix_pickle, polib
      cc-by-sa-30 # data and artwork, some translations
      free # earth images from NASA, some fonts
      cc0 # cick0.wav
    ];
    mainProgram = "singularity";
    maintainers = with lib.maintainers; [ fgaz ];
  };
}
