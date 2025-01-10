@echo off
setlocal EnableDelayedExpansion
title Monitor de Parking

chcp 65001 > nul

cls
echo ================================================
echo          --- Monitor de Estado ---
echo ================================================
echo.
echo Observando cambios en tiempo real...
echo ================================================
echo.

echo. > control.txt

:loop
if exist control.txt (
    cls
    echo ================================================
    echo          --- Monitor de Estado ---
    echo ================================================
    echo.
    echo Última actualización:
    echo --------------------------------
    type control.txt
    echo --------------------------------
    echo.

    findstr /i "SALIR" control.txt >nul 2>&1
    if not errorlevel 1 (
        echo Recibido comando de cierre. Finalizando monitor...
        exit
    )

    del control.txt
)
timeout /t 1 >nul
goto loop
