@echo off
REM ============================================
REM ARK Mobile Enhancement Toolkit
REM decompile-apk.bat
REM Decompila el APK para poder ver y modificar su contenido
REM ============================================

echo.
echo  ==========================================
echo   ARK Mobile Enhancement Toolkit
echo   Decompilador de APK
echo  ==========================================
echo.

REM Buscar el APK en la carpeta original
set APK_FILE=
for %%f in ("C:\ArkMobile\1-original\*.apk") do set APK_FILE=%%f

if "%APK_FILE%"=="" (
    echo [ERROR] No se encontro ningun archivo .apk en C:\ArkMobile\1-original\
    echo.
    echo Asegurate de copiar el APK del juego a esa carpeta.
    echo El archivo deberia llamarse algo como:
    echo   ARK-Survival-Evolved-2.0.29.apk
    echo.
    pause
    exit /b 1
)

echo [INFO] APK encontrado: %APK_FILE%
echo.

REM Verificar que Apktool existe
if not exist "C:\ArkMobile\tools\apktool\apktool.jar" (
    echo [ERROR] No se encontro Apktool.
    echo Ejecuta setup-tools.bat primero.
    pause
    exit /b 1
)

REM Verificar que Java existe
java -version >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Java no esta instalado.
    echo Descargalo de https://adoptium.net/
    pause
    exit /b 1
)

REM Limpiar carpeta destino si ya existe
if exist "C:\ArkMobile\2-workspace\apk-decompiled" (
    echo [INFO] Limpiando decompilacion anterior...
    rmdir /s /q "C:\ArkMobile\2-workspace\apk-decompiled"
)

echo [1/2] Decompilando APK (esto puede tardar 2-5 minutos)...
echo.

cd /d "C:\ArkMobile\tools\apktool"
java -jar apktool.jar d "%APK_FILE%" -o "C:\ArkMobile\2-workspace\apk-decompiled" -f

if %errorLevel% neq 0 (
    echo.
    echo [ERROR] La decompilacion fallo.
    echo Posibles causas:
    echo   - El APK esta corrupto (descargalo de nuevo)
    echo   - Java no esta bien instalado
    echo   - El APK esta protegido (poco probable para esta version)
    pause
    exit /b 1
)

echo.
echo [2/2] Verificando estructura decompilada...
echo.

REM Mostrar estructura
echo Contenido del APK decompilado:
echo.
if exist "C:\ArkMobile\2-workspace\apk-decompiled\AndroidManifest.xml" (
    echo   [OK] AndroidManifest.xml
) else (
    echo   [!!] AndroidManifest.xml NO encontrado
)

if exist "C:\ArkMobile\2-workspace\apk-decompiled\smali" (
    echo   [OK] smali/ (codigo de la app)
) else (
    echo   [!!] smali/ NO encontrado
)

if exist "C:\ArkMobile\2-workspace\apk-decompiled\res" (
    echo   [OK] res/ (recursos graficos)
) else (
    echo   [!!] res/ NO encontrado
)

if exist "C:\ArkMobile\2-workspace\apk-decompiled\lib" (
    echo   [OK] lib/ (bibliotecas nativas .so)
    echo.
    echo   Bibliotecas encontradas:
    dir /b "C:\ArkMobile\2-workspace\apk-decompiled\lib\" 2>nul
) else (
    echo   [!!] lib/ NO encontrado
)

echo.
echo  ==========================================
echo   DECOMPILACION COMPLETADA
echo  ==========================================
echo.
echo   Los archivos estan en:
echo   C:\ArkMobile\2-workspace\apk-decompiled\
echo.
echo   QUE PUEDES HACER AHORA:
echo   - Abre AndroidManifest.xml con Notepad++
echo     para ver la configuracion del juego
echo   - Explora la carpeta res/ para ver las
echo     imagenes de interfaz
echo   - Explora lib/ para ver las bibliotecas
echo     del motor Unreal Engine 4
echo.
pause
