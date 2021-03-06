{ stdenv, pkgs, lib, wrapGAppsHook, makeWrapper, ... }:
with lib;
let
  internalPath = stdenv.lib.makeBinPath (
    with pkgs; [
      (pass.withExtensions (ext: with ext; [ pass-otp ]))
      coreutils
      findutils
      gawk
      gnugrep
      gnused
      graphicsmagick-imagemagick-compat
      grim
      grimshot
      jq
      libnotify
      procps
      rofi
      rofi-systemd
      slurp
      sway-unwrapped
      systemd
      wl-clipboard
      xdg_utils
    ]
  );
in
stdenv.mkDerivation rec {
  name = "sway-scripts";
  src = ./.;
  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  dontConfigure = true;

  unpackPhase = ''
    mkdir ${name}
    cp -R $src/bin ${name}/
  '';

  installPhase = ''
    for file in $(ls ${name}/bin); do
        name=$(basename $file .sh)
        install -Dm0755 ${name}/bin/$file $out/bin/$name
        wrapProgram $out/bin/$name --set PATH "${internalPath}"
    done
  '';

  meta = with stdenv.lib; {
    description = "A helpers for sway wm environment";
    license = licenses.mit;
    platforms = platforms.all;
  };
}
