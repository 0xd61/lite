#!/bin/bash

cflags="-Wall -O3 -msse4.2 -mavx2 -maes -g -std=gnu11 -fno-strict-aliasing -Isrc"
lflags="-lm"

if [[ $* == *windows* ]]; then
  platform="windows"
  outfile="lite.exe"
  compiler="clang"
  cflags="$cflags -DLUA_USE_POPEN -Iwinlib/SDL2-2.26.2/include"
  lflags="$lflags -Lwinlib/SDL2-2.26.2/lib/x64"
  lflags="-lSDL2main $lflags -mwindows -o $outfile res.res"
  #x86_64-w64-mingw32-windres res.rc -O coff -o res.res
else
  platform="unix"
  outfile="lite"
  compiler="clang"
  cflags="$cflags `sdl2-config --cflags` -DLUA_USE_POSIX"
  lflags="$lflags `sdl2-config --libs` -o $outfile"
fi

if command -v ccache >/dev/null; then
  compiler="ccache $compiler"
fi


echo "compiling ($platform)..."
for f in `find src -name "*.c"`; do
  $compiler -c $cflags $f -o "${f//\//_}.o"
  if [[ $? -ne 0 ]]; then
    got_error=true
  fi
done

if [[ ! $got_error ]]; then
  echo "linking..."
  $compiler *.o $lflags
fi

echo "cleaning up..."
rm *.o
rm res.res 2>/dev/null
echo "done"
