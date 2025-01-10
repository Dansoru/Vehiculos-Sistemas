@echo off
cls
setlocal enabledelayedexpansion
title Editor de Parking

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

:: Continuar con el menú principal
:menu_principal
cls
echo -------------------------------------------
echo Terminal de Gestion de Vehiculos
echo -------------------------------------------
echo 1. Gestion de Conductores
echo 2. Gestion de Vehiculos
echo 3. Gestion de Relaciones (Conductor-Vehiculo)
echo 4. Multas
echo 5. Consultas Especiales
echo 6. Salir
echo -------------------------------------------
set /p opcion=Selecciona una opcion:

if "%opcion%"=="1" goto menu_conductores
if "%opcion%"=="2" goto menu_vehiculos
if "%opcion%"=="3" goto menu_relaciones
if "%opcion%"=="4" goto menu_multas
if "%opcion%"=="5" goto menu_consultas
if "%opcion%"=="6" (

echo SALIR > control.txt

exit
)

goto menu_principal

:menu_conductores
cls
echo -------------------------------------------
echo Gestion de Conductores
echo -------------------------------------------
echo 1. Anadir conductor
echo 2. Eliminar conductor
echo 3. Refescar con conductores
echo 4. Buscar conductor por DNI
echo 5. Actualizar datos del conductor
echo 6. Listar conductores con mas de X anos de carnet
echo 7. Regresar al menu principal
echo -------------------------------------------
set /p opcion=Selecciona una opcion:

if "%opcion%"=="1" goto anadir_conductor
if "%opcion%"=="2" goto eliminar_conductor
if "%opcion%"=="3" goto listar_conductores
if "%opcion%"=="4" goto buscar_conductor
if "%opcion%"=="5" goto actualizar_conductor
if "%opcion%"=="6" goto listar_conductores_antiguedad
if "%opcion%"=="7" goto menu_principal

goto menu_conductores

:: Funciones de conductores
:anadir_conductor
cls
echo Introduzca los datos del conductor en el formato: DNI,Nombre,Apellido,Fecha_Carnet
set /p conductor_datos=Datos:
echo %conductor_datos% >> "%conductor_file%"
echo Conductor añadido correctamente.
pause
goto menu_conductores

:eliminar_conductor
cls
echo ==========================================
echo  ELIMINAR CONDUCTOR
echo ==========================================
echo Lista de conductores:
echo ------------------------------------------
:: Mostrar los datos con números para seleccionar
set /a line_num=1
for /f "skip=1 tokens=*" %%A in ('type "%conductor_file%"') do (
  echo !line_num!. %%A
  set /a line_num+=1
)

:: Pedir la línea a eliminar
echo ------------------------------------------
set /p seleccion=Introduce el número del conductor a eliminar:

:: Validar entrada
if "%seleccion%"=="" (
  echo No se seleccionó ninguna línea.
  pause
  goto menu_conductores
)

:: Filtrar las líneas que no coinciden con la seleccionada
set /a current_line=1
(
echo DNI,Nombre,Apellido,Fecha_Carnet
for /f "skip=1 tokens=*" %%A in ('type "%conductor_file%"') do (
  if "!current_line!" NEQ "%seleccion%" echo %%A
  set /a current_line+=1
)
) > temp.csv

:: Reemplazar el archivo original
move /y temp.csv "%conductor_file%" > nul
echo Conductor eliminado correctamente.
pause
goto menu_conductores

:listar_conductores
cls
echo Lista de conductores:
type "%conductor_file%"> control.txt
pause
goto menu_conductores

:buscar_conductor
cls
set /p dni=Introduce el DNI del conductor a buscar:
findstr /i "%dni%," "%conductor_file%"
pause
goto menu_conductores

:actualizar_conductor
cls
set /p dni=Introduce el DNI del conductor a actualizar:
findstr /v /i "%dni%," "%conductor_file%" > temp.csv
set /p nuevo_datos=Introduce los nuevos datos del conductor (DNI,Nombre,Apellido,Fecha_Carnet):
echo %nuevo_datos% >> temp.csv
move /y temp.csv "%conductor_file%"
echo Conductor actualizado correctamente.
pause
goto menu_conductores

:listar_conductores_antiguedad
cls
:: Obtener la fecha actual en formato AAAA-MM-DD
for /f "tokens=2 delims==" %%A in ('"wmic os get localdatetime /value"') do set datetime=%%A
set year=%datetime:~0,4%

:: Solicitar número mínimo de años
set /p min_years=Introduce el número mínimo de años de carnet:

cls
echo ==========================================
echo  CONDUCTORES CON AL MENOS %min_years% AÑOS DE CARNET
echo ==========================================

:: Ruta del archivo CSV (modifica si está en otra ubicación)
set csv_file=conductores.csv

:: Leer el archivo línea por línea
for /f "skip=1 tokens=1,2,3,4 delims=," %%A in ("%csv_file%") do (
  set dni=%%A
  set nombre=%%B
  set apellido=%%C
  set fecha_carnet=%%D
  
  :: Extraer el año de la fecha del carnet
  set year_carnet=!fecha_carnet:~0,4!
  
  :: Calcular años de carnet
  set /a years_carnet=%year% - !year_carnet!
  
  :: Comparar años de carnet con el mínimo requerido
  if !years_carnet! GEQ %min_years% (
    echo DNI: !dni! - Nombre: !nombre! !apellido! - Años de carnet: !years_carnet!
  )
)

pause
goto menu_conductores

:menu_vehiculos
cls
echo -------------------------------------------
echo Gestion de Vehiculos
echo -------------------------------------------
echo 1. Anadir vehiculo
echo 2. Eliminar vehiculo
echo 3. Listar vehiculos
echo 4. Buscar vehiculo por matricula
echo 5. Actualizar datos del vehiculo
echo 6. Listar vehiculos por tipo
echo 7. Listar vehiculos de una marca especifica
echo 8. Listar vehiculos sin conductor asignado
echo 9. Regresar al menu principal
echo -------------------------------------------
set /p opcion=Selecciona una opcion:

if "%opcion%"=="1" goto anadir_vehiculo
if "%opcion%"=="2" goto eliminar_vehiculo
if "%opcion%"=="3" goto listar_vehiculos
if "%opcion%"=="4" goto buscar_vehiculo
if "%opcion%"=="5" goto actualizar_vehiculo
if "%opcion%"=="6" goto listar_vehiculos_tipo
if "%opcion%"=="7" goto listar_vehiculos_marca
if "%opcion%"=="8" goto listar_vehiculos_sin_conductor
if "%opcion%"=="9" goto menu_principal

:anadir_vehiculo
cls
echo Introduzca los datos del vehiculo en el formato: Matricula,Marca,Tipo,Atributo,Valor
set /p vehiculo_datos=Datos:
echo %vehiculo_datos% >> "%vehiculo_file%"
echo Vehiculo anadido correctamente.
pause
goto menu_vehiculos

:eliminar_vehiculo
cls
set /p matricula=Introduce la matricula del vehiculo a eliminar:
findstr /v /i "%matricula%," "%vehiculo_file%" > temp.csv
move /y temp.csv "%vehiculo_file%"
echo Vehiculo eliminado correctamente.
pause
goto menu_vehiculos

:listar_vehiculos
cls
echo Lista de vehiculos:
type "%vehiculo_file%"
pause
goto menu_vehiculos

:buscar_vehiculo
cls
set /p matricula=Introduce la matricula del vehiculo a buscar:
findstr /i "%matricula%," "%vehiculo_file%"
pause
goto menu_vehiculos

:actualizar_vehiculo
cls
set /p matricula=Introduce la matricula del vehiculo a actualizar:
findstr /v /i "%matricula%," "%vehiculo_file%" > temp.csv
set /p nuevo_datos=Introduce los nuevos datos del vehiculo (Matricula,Marca,Tipo,Atributo,Valor):
echo %nuevo_datos% >> temp.csv
move /y temp.csv "%vehiculo_file%"
echo Vehiculo actualizado correctamente.
pause
goto menu_vehiculos

:listar_vehiculos_tipo
cls
set /p tipo=Introduce el tipo de vehiculo a buscar:
echo Vehiculos de tipo %tipo%:
findstr /i "%tipo%" "%vehiculo_file%"
pause
goto menu_vehiculos

:listar_vehiculos_marca
cls
set /p marca=Introduce la marca de vehiculo a buscar:
echo Vehiculos de la marca %marca%:
findstr /i "%marca%" "%vehiculo_file%"
pause
goto menu_vehiculos

:listar_vehiculos_sin_conductor
cls
echo Vehiculos sin conductor asignado:
for /f "tokens=2 delims=," %%A in ("%relaciones_file%") do @echo %%A > temp_matriculas.csv
for /f "tokens=1 delims=," %%B in ("%vehiculo_file%") do (
  findstr /i /v "%%B" temp_matriculas.csv > nul
  if errorlevel 1 echo %%B
)
del temp_matriculas.csv
pause
goto menu_vehiculos

:menu_relaciones
cls
echo -------------------------------------------
echo Gestion de Relaciones (Conductor-Vehiculo)
echo -------------------------------------------
echo 1. Asignar conductor a vehiculo
echo 2. Eliminar relacion conductor-vehiculo
echo 3. Listar relaciones existentes
echo 4. Buscar relacion por DNI o Matricula
echo 5. Regresar al menu principal
echo -------------------------------------------
set /p opcion=Selecciona una opcion:

if "%opcion%"=="1" goto asignar_relacion
if "%opcion%"=="2" goto eliminar_relacion
if "%opcion%"=="3" goto listar_relaciones
if "%opcion%"=="4" goto buscar_relacion
if "%opcion%"=="5" goto menu_principal

goto menu_relaciones

:asignar_relacion
cls
echo Introduzca los datos de la relacion en el formato: DNI,Matricula
set /p relacion_datos=Datos:
echo %relacion_datos% >> "%relaciones_file%"
echo Relacion asignada correctamente.
pause
goto menu_relaciones

:eliminar_relacion
cls
set /p filtro=Introduce el DNI o la Matricula para eliminar la relacion:
findstr /v /i "%filtro%" "%relaciones_file%" > temp.csv
move /y temp.csv "%relaciones_file%"
echo Relacion eliminada correctamente.
pause
goto menu_relaciones

:listar_relaciones
cls
echo Lista de relaciones existentes:
type "%relaciones_file%"
pause
goto menu_relaciones

:buscar_relacion
cls
set /p filtro=Introduce el DNI o la Matricula a buscar:
findstr /i "%filtro%" "%relaciones_file%"
pause
goto menu_relaciones

goto menu_principal

:menu_consultas
cls
echo -------------------------------------------
echo Consultas Especiales
echo -------------------------------------------
echo 1. Listar conductores con mas de un vehiculo
echo 2. Listar vehiculos asignados a un conductor
echo 3. Regresar al menu principal
echo -------------------------------------------
set /p opcion=Selecciona una opcion:

if "%opcion%"=="1" goto listar_conductores_con_vehiculos
if "%opcion%"=="2" goto listar_vehiculos_por_conductor
if "%opcion%"=="3" goto menu_principal

goto menu_consultas

:listar_conductores_con_vehiculos
cls
echo Lista de conductores con mas de un vehiculo:
for /f "tokens=1 delims=," %%A in ("%relaciones_file%") do (
  findstr /c:"%%A" "%relaciones_file%" > nul
  if !errorlevel! gtr 1 echo %%A
)
pause
goto menu_consultas

:listar_vehiculos_por_conductor
cls
set /p dni=Introduce el DNI del conductor:
echo Vehiculos asignados al conductor %dni%:
findstr /i "%dni%" "%relaciones_file%" > temp.csv
for /f "tokens=2 delims=," %%B in (temp.csv) do (
  findstr /i "%%B" "%vehiculo_file%"
)
del temp.csv
pause
goto menu_consultas

:menu_multas
cls
echo -------------------------------------------
echo Gestion de Multas
echo -------------------------------------------
echo 1. Anadir multa
echo 2. Eliminar multa
echo 3. Listar multas
echo 4. Buscar multa por ID
echo 5. Actualizar estado de multa
echo 6. Regresar al menu principal
echo -------------------------------------------
set /p opcion=Selecciona una opcion:

if "%opcion%"=="1" goto anadir_multa
if "%opcion%"=="2" goto eliminar_multa
if "%opcion%"=="3" goto listar_multas
if "%opcion%"=="4" goto buscar_multa
if "%opcion%"=="5" goto actualizar_multa
if "%opcion%"=="6" goto menu_principal

goto menu_multas

:: Funciones de multas
:anadir_multa
cls
echo Introduzca los datos de la multa en el formato: ID,DNI,Matrícula,Descripción,Monto,Estado,Fecha
set /p multa_datos=Datos:
echo %multa_datos% >> "%multas_file%"
echo Multa añadida correctamente.
pause
goto menu_multas

:eliminar_multa
cls
set /p id=Introduce el ID de la multa a eliminar:
findstr /v /i "%id%," "%multas_file%" > temp.csv
move /y temp.csv "%multas_file%"
echo Multa eliminada correctamente.
pause
goto menu_multas

:listar_multas
cls
echo Lista de multas:
type "%multas_file%"
pause
goto menu_multas

:buscar_multa
cls
set /p id=Introduce el ID de la multa a buscar:
findstr /i "%ID%," "%multas_file%"
pause
goto menu_multas

:actualizar_multa
cls
set /p id=Introduce el ID de la multa a actualizar:
findstr /v /i "%id%," "%multas_file%" > temp.csv
set /p nuevo_datos=Introduce los nuevos datos de la multa (ID,DNI,Matrícula,Descripción,Monto,Estado,Fecha):
echo %nuevo_datos% >> temp.csv
move /y temp.csv "%multas_file%"
echo Multa actualizada correctamente.
pause
goto menu_multas