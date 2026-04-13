@echo off
REM ============================================
REM ARK Mobile Enhancement Toolkit
REM setup-tools.bat
REM Descarga e instala todas las herramientas necesarias
REM ============================================
REM Ejecutar como Administrador

echo.
echo  ==========================================
echo   ARK Mobile Enhancement Toolkit
echo   Instalador de Herramientas
echo  ==========================================
echo.

REM Verificar permisos de administrador
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo [ERROR] Necesitas ejecutar esto como Administrador!
    echo Click derecho en setup-tools.bat ^> "Ejecutar como administrador"
    pause
    exit /b 1
)

REM Crear estructura de carpetas
echo [1/5] Creando estructura de carpetas...
mkdir "C:\ArkMobile\1-original" 2>nul
mkdir "C:\ArkMobile\2-workspace\apk-decompiled" 2>nul
mkdir "C:\ArkMobile\2-workspace\assets-extraidos" 2>nul
mkdir "C:\ArkMobile\2-workspace\patches" 2>nul
mkdir "C:\ArkMobile\3-build" 2>nul
mkdir "C:\ArkMobile\tools\apktool" 2>nul
mkdir "C:\ArkMobile\tools\umodel" 2>nul
mkdir "C:\ArkMobile\tools\unrealpak" 2>nul
echo      [OK] Carpetas creadas en C:\ArkMobile\

REM Verificar Java
echo.
echo [2/5] Verificando Java JDK...
java -version >nul 2>&1
if %errorLevel% neq 0 (
    echo      [!] Java NO esta instalado
    echo      Abriendo pagina de descarga...
    start https://adoptium.net/
    echo      DESCARGA: Java 17 LTS para Windows x64 (.msi)
    echo      IMPORTANTE: Marca "Add to PATH" durante la instalacion
    echo      Instala Java, cierra esta ventana y ejecuta este script de nuevo.
    pause
    exit /b 1
) else (
    echo      [OK] Java esta instalado
    java -version 2>&1 | findstr /i "version"
)

REM Verificar curl (para descargar archivos)
echo.
echo [3/5] Verificando curl...
curl --version >nul 2>&1
if %errorLevel% neq 0 (
    echo      [!] curl no esta disponible
    echo      Descargando...
    powershell -Command "Invoke-WebRequest -Uri 'https://curl.se/windows/dl-7.85.0/curl-7.85.0-win64-mingw.zip' -OutFile '%TEMP%\curl.zip'"
    powershell -Command "Expand-Archive -Path '%TEMP%\curl.zip' -DestinationPath 'C:\ArkMobile\tools\curl' -Force"
    echo      [OK] curl descargado
) else (
    echo      [OK] curl esta disponible
)

REM Descargar Apktool
echo.
echo [4/5] Verificando Apktool...
if not exist "C:\ArkMobile\tools\apktool\apktool.jar" (
    echo      [!] Apktool no encontrado, descargando...
    curl -L -o "C:\ArkMobile\tools\apktool\apktool.jar" "https://bitbucket.org/AaronFeng753/waifu2x-extension-gui/downloads/apktool_2.9.3.jar"
    echo      [OK] Apktool descargado
    
    REM Crear apktool.bat wrapper
    echo @echo off > "C:\ArkMobile\tools\apktool\apktool.bat"
    echo java -jar "%%~dp0apktool.jar" %%* >> "C:\ArkMobile\tools\apktool\apktool.bat"
    echo      [OK] Wrapper apktool.bat creado
) else (
    echo      [OK] Apktool ya esta instalado
)

REM Crear scripts de trabajo
echo.
echo [5/5] Creando scripts de trabajo...

REM Script: decompile-apk.bat
echo @echo off > "C:\ArkMobile\tools\decompile-apk.bat"
echo echo Decompilando APK de ARK Mobile... >> "C:\ArkMobile\tools\decompile-apk.bat"
echo echo. >> "C:\ArkMobile\tools\decompile-apk.bat"
echo if not exist "C:\ArkMobile\1-original\*.apk" ( >> "C:\ArkMobile\tools\decompile-apk.bat"
echo     echo [ERROR] No se encontro APK en C:\ArkMobile\1-original\ >> "C:\ArkMobile\tools\decompile-apk.bat"
echo     pause >> "C:\ArkMobile\tools\decompile-apk.bat"
echo     exit /b 1 >> "C:\ArkMobile\tools\decompile-apk.bat"
echo ^) >> "C:\ArkMobile\tools\decompile-apk.bat"
echo cd C:\ArkMobile\tools\apktool >> "C:\ArkMobile\tools\decompile-apk.bat"
echo java -jar apktool.jar d "C:\ArkMobile\1-original\%%1" -o "C:\ArkMobile\2-workspace\apk-decompiled" -f >> "C:\ArkMobile\tools\decompile-apk.bat"
echo echo. >> "C:\ArkMobile\tools\decompile-apk.bat"
echo echo [OK] APK decompilado en C:\ArkMobile\2-workspace\apk-decompiled >> "C:\ArkMobile\tools\decompile-apk.bat"
echo pause >> "C:\ArkMobile\tools\decompile-apk.bat"

echo      [OK] Scripts creados

REM Resumen final
echo.
echo  ==========================================
echo   INSTALACION COMPLETADA
echo  ==========================================
echo.
echo   Carpetas:     C:\ArkMobile\
echo   APK Tool:     C:\ArkMobile\tools\apktool\
echo.
echo   PROXIMO PASO:
echo   1. Copia tu APK a C:\ArkMobile\1-original\
echo   2. Copia tu OBB a C:\ArkMobile\1-original\
echo   3. Ejecuta: decompile-apk.bat
echo.
pause
