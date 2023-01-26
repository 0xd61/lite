@echo off
call build.bat
rm lite.zip
cp winlib\SDL2-2.26.2\lib\x64\SDL2.dll SDL2.dll
tar.exe -a -c -f lite.zip lite.exe SDL2.dll data 