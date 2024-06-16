{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, makeWrapper
, unzip
, libGL
, glib
, fontconfig
, xorg
, xkeyboard_config
, dbus
, wayland
, libxkbcommon 
, libxml2
}:
stdenv.mkDerivation {
  name = "binaryninja-free";
  buildInputs = [
    unzip
    libGL
    stdenv.cc.cc.lib
    glib
    fontconfig
    dbus
    wayland
    libxml2
    libxkbcommon
    xorg.libXi
    xorg.libXrender
    xorg.xcbutilrenderutil
    xorg.xcbutilimage
    xorg.xcbutilwm
    xorg.xcbutilkeysyms
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  src = fetchurl {
    url = "https://cdn.binary.ninja/installers/binaryninja_free_linux.zip";
    sha256 = "07iqwzyipilr0n6axrqbpnl123dd8s3w9k2s3k15rk2g8pfr3l23";
  };

  #buildPhase = ":";
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/opt
    cp -r * $out/opt
    chmod +x $out/opt/binaryninja
    makeWrapper $out/opt/binaryninja \
        $out/bin/binaryninja \
        --prefix "QT_XKB_CONFIG_ROOT" ":" "${xkeyboard_config}/share/X11/xkb"
  '';

  meta = with lib; {
    description = "Binary Ninja is an interactive decompiler, disassembler, debugger, and binary analysis platform built by reverse engineers, for reverse engineers.";
    homepage = "https://binary.ninja/";
    license = licenses.unfree;
    platforms = platforms.linux;
  };
}
