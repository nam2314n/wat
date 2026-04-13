@echo off
REM ============================================
REM ARK Mobile Enhancement Toolkit
REM extract-assets.bat
REM Extrae texturas, modelos, audio y mas del OBB
REM ============================================

echo.
echo  ==========================================
echo   ARK Mobile Enhancement Toolkit
REM   Extractor de Assets del Juego
echo  ==========================================
echo.

REM Buscar el OBB
set OBB_FILE=
for %%f in ("C:\ArkMobile\1-original\*.obb") do set OBB_FILE=%%f

if "%OBB_FILE%"=="" (
    echo [ERROR] No se encontro ningun archivo .obb en C:\ArkMobile\1-original\
    echo.
    echo Asegurate de copiar el OBB del juego a esa carpeta.
    echo El archivo deberia llamarse:
    echo   com.studiowildcard.wardrumstudios.ark.obb
    echo.
    pause
    exit /b 1
)

echo [INFO] OBB encontrado: %OBB_FILE%
echo [INFO] Tamano:
for %%A in ("%OBB_FILE%") do echo   %%~zA bytes
echo.

REM Crear carpeta de destino
if not exist "C:\ArkMobile\2-workspace\assets-extraidos" mkdir "C:\ArkMobile\2-workspace\assets-extraidos"

echo ==========================================
echo   OPCIONES DE EXTRACCION
echo ==========================================
echo.
echo   El OBB contiene archivos .pak de Unreal Engine.
echo   Para extraerlos tienes dos opciones:
echo.
echo   [1] Usar UModel (recomendado para principiantes)
echo       - Extrae texturas, modelos, animaciones, audio
echo       - Interfaz grafica facil de usar
echo.
echo   [2] Usar UnrealPak (para usuarios avanzados)
echo       - Extrae archivos .pak completos
echo       - Mas control pero requiere mas conocimiento
echo.
set /p OPTION="Elige una opcion (1 o 2): "

if "%OPTION%"=="1" goto umodel_extract
if "%OPTION%"=="2" goto unrealpak_extract
echo [ERROR] Opcion no valida.
pause
exit /b 1

:umodel_extract
echo.
echo [INFO] Abriendo UModel...
echo.
echo ==========================================
echo   INSTRUCCIONES PARA UMODEL
echo ==========================================
echo.
echo   1. UModel se va a abrir
echo   2. Ve a: File ^> Open
echo   3. Navega a la carpeta del OBB y busca archivos .pak
echo   4. Selecciona el .pak principal
echo   5. Elige los tipos de assets que quieres extraer
echo   6. Usa File ^> Export All para extraer todo
echo.
echo IMPORTANTE: Configura UModel asi:
echo   - Engine: Unreal Engine 4
echo   - Game: ARK Survival Evolved
echo.
if exist "C:\ArkMobile\tools\umodel\umodel.exe" (
    start "" "C:\ArkMobile\tools\umodel\umodel.exe"
    echo [OK] UModel abierto
) else (
    echo [!] UModel no encontrado.
    echo Descargalo de https://www.gildor.org/projects/umodel#downloads
    echo y extraelo en C:\ArkMobile\tools\umodel\
)
echo.
pause
exit /b 0

:unrealpak_extract
echo.
echo [INFO] Buscando UnrealPak...

REM Buscar UnrealPak en la instalacion de UE4
set UE4_PAK=
if exist "C:\Program Files\Epic Games\UE_4.27\Engine\Binaries\Win64\UnrealPak.exe" (
    set "UE4_PAK=C:\Program Files\Epic Games\UE_4.27\Engine\Binaries\Win64\UnrealPak.exe"
)
if exist "C:\Program Files (x86)\Epic Games\UE_4.27\Engine\Binaries\Win64\UnrealPak.exe" (
    set "UE4_PAK=C:\Program Files (x86)\Epic Games\UE_4.27\Engine\Binaries\Win64\UnrealPak.exe"
)

if "%UE4_PAK%"=="" (
    echo [!] UnrealPak no encontrado.
    echo Necesitas instalar Unreal Engine 4.27 desde:
    echo https://www.unrealengine.com/download
    echo.
    echo Mientras tanto, usa la opcion 1 (UModel) en su lugar.
    pause
    exit /b 1
)

echo [OK] UnrealPak encontrado: %UE4_PAK%
echo.
echo [INFO] Para extraer un archivo .pak, ejecuta:
echo.
echo   "%UE4_PAK%" "ruta-al-archivo.pak" -Extract "C:\ArkMobile\2-workspace\assets-extraidos\"
echo.
echo Necesitas encontrar los archivos .pak dentro del OBB.
echo El OBB es un contenedor, los .pak estan adentro.
echo.
pause
exit /b 0
