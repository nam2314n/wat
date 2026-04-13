@echo off
REM ============================================
REM ARK Mobile Enhancement Toolkit
REM rebuild-apk.bat
REM Recompila el APK modificado listo para instalar
REM ============================================

echo.
echo  ==========================================
echo   ARK Mobile Enhancement Toolkit
echo   Reconstructor de APK
echo  ==========================================
echo.

REM Verificar que la carpeta decompilada existe
if not exist "C:\ArkMobile\2-workspace\apk-decompiled\AndroidManifest.xml" (
    echo [ERROR] No se encontro un APK decompilado.
    echo Ejecuta decompile-apk.bat primero.
    pause
    exit /b 1
)

REM Verificar que Apktool existe
if not exist "C:\ArkMobile\tools\apktool\apktool.jar" (
    echo [ERROR] No se encontro Apktool.
    echo Ejecuta setup-tools.bat primero.
    pause
    exit /b 1
)

echo [1/3] Recompilando APK modificado...
echo   (Esto puede tardar 5-10 minutos)
echo.

cd /d "C:\ArkMobile\tools\apktool"
java -jar apktool.jar b "C:\ArkMobile\2-workspace\apk-decompiled" -o "C:\ArkMobile\3-build\ARK-Modified.apk"

if %errorLevel% neq 0 (
    echo.
    echo [ERROR] La recompilacion fallo.
    echo.
    echo Causas comunes:
    echo   - Modificaste algo mal en el codigo smali
    echo   - Borriste un archivo necesario
    echo   - El AndroidManifest.xml tiene un error de sintaxis
    echo.
    echo SOLUCION:
    echo   - Vuelve a decompilar desde el APK original
    echo   - Aplica solo las modificaciones indicadas
    echo   - No modifiques archivos que no entiendas
    pause
    exit /b 1
)

echo.
echo [2/3] APK recompilado exitosamente.
echo.

REM Preguntar si quiere firmar el APK
echo [3/3] FIRMA DEL APK
echo.
echo Para instalar un APK modificado en tu telefono,
echo necesitas firmarlo con un certificado.
echo.
echo Opciones:
echo   [1] Firmar con debug key (recomendado para pruebas)
echo   [2] Firmar con key personal (para distribucion)
echo   [3] Omitir firma (lo tendras que firmar manualmente)
echo.
set /p SIGN_OPTION="Elige una opcion (1, 2 o 3): "

if "%SIGN_OPTION%"=="1" (
    echo.
    echo [INFO] Firmando con debug key...

    REM Verificar si apksigner o jarsigner estan disponibles
    REM Usamos uber-apk-signer como alternativa simple
    echo Buscando herramientas de firma...

    if exist "C:\ArkMobile\tools\uber-apk-signer.jar" (
        java -jar "C:\ArkMobile\tools\uber-apk-signer.jar" --apks "C:\ArkMobile\3-build\ARK-Modified.apk" --out "C:\ArkMobile\3-build\"
        echo [OK] APK firmado exitosamente
    ) else (
        echo.
        echo [!] No se encontro herramienta de firma.
        echo.
        echo Puedes firmar el APK manualmente con:
        echo   - apksigner (viene con Android SDK Build Tools)
        echo   - uber-apk-signer (descarga de GitHub)
        echo   - Online: busca "APK signer online" en Google
        echo.
        echo Tu APK modificado esta en:
        echo   C:\ArkMobile\3-build\ARK-Modified.apk
    )
) else (
    echo Tu APK modificado esta en:
    echo   C:\ArkMobile\3-build\ARK-Modified.apk
)

echo.
echo  ==========================================
echo   RECOMPILACION COMPLETADA
echo  ==========================================
echo.
echo   APK modificado: C:\ArkMobile\3-build\ARK-Modified.apk
echo.
echo   PARA INSTALAR EN TU TELEFONO:
echo   1. Copia el APK a tu telefono
echo   2. Activa "Fuentes desconocidas" en ajustes
echo   3. Abre el APK y sigue las instrucciones
echo   4. Copia el OBB a: Android/data/com.studiowildcard.wardrumstudios.ark/
echo.
echo   IMPORTANTE: Si el juego no abre:
echo   - Asegurate de que el APK este firmado
echo   - Verifica que el OBB este en la ruta correcta
echo   - Prueba desinstalar la version original primero
echo.
pause
