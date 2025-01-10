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
pause
exit


:buscarRelacionVehiculo
setlocal
set "DNI=%~1"
for /f "usebackq skip=1 tokens=1,2 delims=;" %%F in ("%relaciones_file%") do (
    if "%%F"=="%DNI%" (
        :: Mostrar la relación DNI - Matrícula
        echo - Relacionado con Vehiculo: %%G
        call :buscarVehiculo %%G
    )
)
endlocal

:buscarVehiculo
setlocal
set "Matricula=%~1"
for /f "usebackq skip=1 tokens=1,2,3,4,5 delims=," %%H in ("%vehiculo_file%") do (
    if "%%H"=="%Matricula%" (
        :: Mostrar los detalles del vehículo
       echo funionaaa
    )
)
endlocal



