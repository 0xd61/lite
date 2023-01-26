@echo off

set CommonCompilerFlags=-MD -nologo -fp:fast -EHa -Od -WX- -W4 -Oi -GR- -Gm- -GS -wd4100 -FC -Z7
set CommonCompilerFlags=%CommonCompilerFlags%
set CommonLinkerFlags=-opt:ref shell32.lib user32.lib gdi32.lib winmm.lib bcrypt.lib kernel32.lib SDL2.lib SDL2main.lib

if not exist build mkdir build
if not exist build\lib mkdir build\lib

rc res.rc
cl %CommonCompilerFlags% -Isrc -Iwinlib\SDL2-2.26.2\include -c -Fobuild\lib\ src\api\*.c src\lib\lua52\*.c src\lib\stb\*.c
cl %CommonCompilerFlags% -Isrc -Iwinlib\SDL2-2.26.2\include -Fobuild\ src\*.c  build\lib\*.obj res.res /link /SUBSYSTEM:windows -PDB:lite_%random%.pdb %CommonLinkerFlags% /LIBPATH:winlib/SDL2-2.26.2/lib/x64 /out:lite.exe