@echo off
echo Compilando juego...

rgbasm -o main.o main.asm
if %errorlevel% neq 0 (
    echo Error en rgbasm
    pause
    exit /b 1
)

rgblink -o game.gb main.o
if %errorlevel% neq 0 (
    echo Error en rgblink
    pause
    exit /b 1
)

rgbfix -v -p 0 game.gb
if %errorlevel% neq 0 (
    echo Error en rgbfix
    pause
    exit /b 1
)

echo Compilacion exitosa!
echo Ejecutando en BGB...

start "" "C:\Projects\bgb\bgb.exe" "game.gb"