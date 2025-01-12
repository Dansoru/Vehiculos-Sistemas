@echo off
cls
setlocal EnableDelayedExpansion
title Monitor de Parking

chcp 65001 > nul

:: Establecer la carpeta Base de Datos
set "base_dir=%cd%\Base de Datos"

:: Crear la carpeta Base de Datos si no existe
if not exist "%base_dir%" (
  mkdir "%base_dir%"
)

if not exist control.txt (
  echo. > control.txt
)

:: Inicializa las variables de control
set "PaseControl="
set "NEWcontrol="
set "control_file=control.txt"

:: Lee el contenido inicial de control.txt
for /f "delims=" %%A in (%control_file%) do (
    set "PaseControl=%%A"
)


:: Definir las rutas completas de los archivos
set "conductor_file=%base_dir%\conductores.csv"
set "vehiculo_file=%base_dir%\vehiculos.csv"
set "relaciones_file=%base_dir%\relaciones.csv"
set "multas_file=%base_dir%\multas.csv"

:: Crear los archivos si no existen
if not exist "%conductor_file%" (
  echo DNI,Nombre,Apellido,Fecha_Carnet > "%conductor_file%"
)
if not exist "%vehiculo_file%" (
  echo Matricula,Marca,Tipo,Atributo,Valor > "%vehiculo_file%"
)
if not exist "%relaciones_file%" (
  echo DNI -> Matricula > "%relaciones_file%"
)
if not exist "%multas_file%" (
  echo ID,DNI,Matrícula,Descripción,Monto,Estado,Fecha > "%multas_file%"
)

:inicio
cls
echo ===================================================
echo  --- Monitor de Estado ---
echo ===================================================
echo Estacionamiento: Central Parking
echo Fecha y hora: %date% - %time:~0,8%
echo ---------------------------------------------------

:: Inicializar número de línea
set /a line_number=1

:: Leer el archivo de conductores y mostrar la información
echo CONDUCTORES:
echo ===================================================

for /f "usebackq skip=1 tokens=1,2,3,4 delims=;" %%A in ("%conductor_file%") do (
  
  :: Formatear el número de ID con ceros a la izquierda
  set "formatted_id=00!line_number!"
  set "formatted_id=!formatted_id:~-2!"
  
  echo ID: !formatted_id! ^| DNI: %%A ^| Fecha Carnet: %%D ^| Nombre: %%B %%C
  
  set /a line_number+=1
  echo --------------------------------------------------------------------------------
    :: Llamar a las funciones para buscar vehículos y multas
    call :buscarRelacionVehiculo %%A
    echo.
    echo.

)

echo ===================================================
echo.
echo ---------------------------------------------------
echo Última acción registrada:
echo.
type control.txt
echo.
echo ---------------------------------------------------


:bucle
:: Espera un segundo antes de comprobar el archivo
timeout /t 1 /nobreak >nul

:: Lee el contenido actual de control.txt
for /f "delims=" %%A in (%control_file%) do (
    set "NEWcontrol=%%A"
)

:: Si el contenido ha cambiado, realiza la acción
if not "%PaseControl%" == "%NEWcontrol%" (
    echo El archivo ha cambiado. Ejecutando acción...

    :: Aquí va la acción que deseas realizar cuando el archivo cambie
    echo Cambios detectados, procesando...

    :: Actualiza el valor de PaseControl con el nuevo contenido
    set "PaseControl=%NEWcontrol%"

    timeout /t 5 /nobreak >nul

    goto inicio
)

goto bucle


:buscarRelacionVehiculo
setlocal
set "DNI_REL=%~1"
set "RELACIONES_ENCONTRADAS=0"  :: Variable para rastrear si se encuentran relaciones

for /f "usebackq skip=1 tokens=1,2 delims=;" %%F in ("%relaciones_file%") do (
    if "%%F"=="%DNI_REL%" (
        set "RELACIONES_ENCONTRADAS=1"  :: Marca que se encontró al menos una relación
        call :buscarVehiculo %%G
    )
)

if "%RELACIONES_ENCONTRADAS%"=="0" (
    echo x ^[ERROR^] No se encontraron relaciones para el DNI: %DNI_REL%
    echo.
)

endlocal
exit /b

:buscarVehiculo
setlocal
set "VEHICULO_MATRICULA=%~1"
set "VEHICULO_ENCONTRADO=0"  :: Variable para verificar si se encontró el vehículo

for /f "usebackq skip=1 tokens=1,2,3,4,5 delims=;" %%I in ("%vehiculo_file%") do (
    if "%%I"=="%VEHICULO_MATRICULA%" (
        set "VEHICULO_ENCONTRADO=1"  :: Marca que se encontró el vehículo
        echo - %%K : %%J ^(%%I^) ^[%%L: %%M^]
        call :multas %%A
    )
)

if "%VEHICULO_ENCONTRADO%"=="0" (
    echo x ^[ERROR^] No se encontró información sobre el vehículo con matrícula: %VEHICULO_MATRICULA%
    echo.
)

endlocal
exit /b

:multas
setlocal
set "DNI=%~1"                   
for /f "usebackq skip=1 tokens=1,2,3,4,5,6,7 delims=;" %%F in ("%multas_file%") do (
    if "%%G"=="%DNI%" (
      echo  + Multa %%F: ^(%%J€^) **^[%%K^]** - %%L ^| "%%I"
    )
)

endlocal
exit /b

