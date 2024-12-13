@echo off
cls
setlocal enabledelayedexpansion

chcp 65001 > nul

:: Definir las rutas de los archivos de datos
set conductor_file=conductores.csv
set vehiculo_file=vehiculos.csv
set relaciones_file=relaciones.csv

:: Crear los archivos si no existen
if not exist %conductor_file% (echo DNI,Nombre,Apellido,Fecha_Carnet > %conductor_file%)
if not exist %vehiculo_file% (echo Matricula,Marca,Tipo,Atributo,Valor > %vehiculo_file%)
if not exist %relaciones_file% (echo DNI -> Matricula > %relaciones_file%)

:menu_principal
cls
echo -------------------------------------------
echo Terminal de Gestión de Vehiculos
echo -------------------------------------------
echo 1. Gestión de Conductores
echo 2. Gestión de Vehiculos
echo 3. Gestión de Relaciones (Conductor-Vehiculo)
echo 4. Consultas Especiales
echo 5. Salir
echo -------------------------------------------
set /p opcion=Selecciona una opcion:

if "%opcion%"=="1" goto menu_conductores
if "%opcion%"=="2" goto menu_vehiculos
if "%opcion%"=="3" goto menu_relaciones
if "%opcion%"=="4" goto menu_consultas
if "%opcion%"=="5" exit

goto menu_principal

:menu_conductores
cls
echo -------------------------------------------
echo Gestión de Conductores
echo -------------------------------------------
echo 1. Añadir conductor
echo 2. Eliminar conductor
echo 3. Listar conductores
echo 4. Buscar conductor por DNI
echo 5. Actualizar datos del conductor
echo 6. Listar conductores con mas de X anos de carnet
echo 7. Regresar al menu principal
echo -------------------------------------------
set /p opcion=Selecciona una opcion:

if "%opcion%"=="1" goto Añadir_conductor
if "%opcion%"=="2" goto eliminar_conductor
if "%opcion%"=="3" goto listar_conductores
if "%opcion%"=="4" goto buscar_conductor
if "%opcion%"=="5" goto actualizar_conductor
if "%opcion%"=="6" goto listar_conductores_antiguedad
if "%opcion%"=="7" goto menu_principal

goto menu_conductores

:: Funciones de conductores
:Añadir_conductor
cls
echo Introduzca los datos del conductor en el formato: DNI,Nombre,Apellido,Fecha_Carnet
set /p conductor_datos=Datos:
echo %conductor_datos% >> %conductor_file%
echo Conductor añadido correctamente.
pause
goto menu_conductores

:eliminar_conductor
cls
set /p dni=Introduce el DNI del conductor a eliminar:
findstr /v /i "%dni%," %conductor_file% > temp.csv
move /y temp.csv %conductor_file%
echo Conductor eliminado correctamente.
pause
goto menu_conductores

:listar_conductores
cls
echo Lista de conductores:
type %conductor_file%
pause
goto menu_conductores

:buscar_conductor
cls
set /p dni=Introduce el DNI del conductor a buscar:
findstr /i "%dni%," %conductor_file%
pause
goto menu_conductores

:actualizar_conductor
cls
set /p dni=Introduce el DNI del conductor a actualizar:
findstr /v /i "%dni%," %conductor_file% > temp.csv
set /p nuevo_datos=Introduce los nuevos datos del conductor (DNI,Nombre,Apellido,Fecha_Carnet):
echo %nuevo_datos% >> temp.csv
move /y temp.csv %conductor_file%
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
echo   CONDUCTORES CON AL MENOS %min_years% AÑOS DE CARNET
echo ==========================================

:: Ruta del archivo CSV (modifica si está en otra ubicación)
set csv_file=conductores.csv

:: Leer el archivo línea por línea
for /f "skip=1 tokens=1,2,3,4 delims=," %%A in (%csv_file%) do (
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
echo Gestión de Vehiculos
echo -------------------------------------------
echo 1. Añadir vehiculo
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

if "%opcion%"=="1" goto Añadir_vehiculo
if "%opcion%"=="2" goto eliminar_vehiculo
if "%opcion%"=="3" goto listar_vehiculos
if "%opcion%"=="4" goto buscar_vehiculo
if "%opcion%"=="5" goto actualizar_vehiculo
if "%opcion%"=="6" goto listar_vehiculos_tipo
if "%opcion%"=="7" goto listar_vehiculos_marca
if "%opcion%"=="8" goto listar_vehiculos_sin_conductor
if "%opcion%"=="9" goto menu_principal

:Añadir_vehiculo
cls
echo Introduzca los datos del vehiculo en el formato: Matricula,Marca,Tipo,Atributo,Valor
set /p vehiculo_datos=Datos:
echo %vehiculo_datos% >> %vehiculo_file%
echo Vehiculo añadido correctamente.
pause
goto menu_vehiculos

:eliminar_vehiculo
cls
set /p matricula=Introduce la matricula del vehiculo a eliminar:
findstr /v /i "%matricula%," %vehiculo_file% > temp.csv
move /y temp.csv %vehiculo_file%
echo Vehiculo eliminado correctamente.
pause
goto menu_vehiculos

:listar_vehiculos
cls
echo Lista de vehiculos:
type %vehiculo_file%
pause
goto menu_vehiculos

:buscar_vehiculo
cls
set /p matricula=Introduce la matricula del vehiculo a buscar:
findstr /i "%matricula%," %vehiculo_file%
pause
goto menu_vehiculos

:actualizar_vehiculo
cls
set /p matricula=Introduce la matricula del vehiculo a actualizar:
findstr /v /i "%matricula%," %vehiculo_file% > temp.csv
set /p nuevo_datos=Introduce los nuevos datos del vehiculo (Matricula,Marca,Tipo,Atributo,Valor):
echo %nuevo_datos% >> temp.csv
move /y temp.csv %vehiculo_file%
echo Vehiculo actualizado correctamente.
pause
goto menu_vehiculos

:listar_vehiculos_tipo
cls
set /p tipo=Introduce el tipo de vehiculo a buscar:
echo Vehiculos de tipo %tipo%:
findstr /i "%tipo%" %vehiculo_file%
pause
goto menu_vehiculos

:listar_vehiculos_marca
cls
set /p marca=Introduce la marca de vehiculo a buscar:
echo Vehiculos de la marca %marca%:
findstr /i "%marca%" %vehiculo_file%
pause
goto menu_vehiculos

:listar_vehiculos_sin_conductor
cls
echo Vehiculos sin conductor asignado:
for /f "tokens=2 delims=," %%A in (%relaciones_file%) do @echo %%A > temp_matriculas.csv
for /f "tokens=1 delims=," %%B in (%vehiculo_file%) do (
    findstr /i /v "%%B" temp_matriculas.csv > nul
    if errorlevel 1 echo %%B
)
del temp_matriculas.csv
pause
goto menu_vehiculos

:menu_relaciones
cls
echo -------------------------------------------
echo Gestión de Relaciones (Conductor-Vehiculo)
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
echo %relacion_datos% >> %relaciones_file%
echo Relacion asignada correctamente.
pause
goto menu_relaciones

:eliminar_relacion
cls
set /p filtro=Introduce el DNI o la Matricula para eliminar la relacion:
findstr /v /i "%filtro%" %relaciones_file% > temp.csv
move /y temp.csv %relaciones_file%
echo Relacion eliminada correctamente.
pause
goto menu_relaciones

:listar_relaciones
cls
echo Lista de relaciones existentes:
type %relaciones_file%
pause
goto menu_relaciones

:buscar_relacion
cls
set /p filtro=Introduce el DNI o la Matricula a buscar:
findstr /i "%filtro%" %relaciones_file%
pause
goto menu_relaciones

goto menu_principal

:menu_consultas
cls
echo -------------------------------------------
echo Consultas Especiales
echo -------------------------------------------
echo 1. Listar conductores con mas de un vehiculo asignado
echo 2. Buscar vehiculos por tipo o atributo especifico
echo 3. Regresar al menu principal
echo -------------------------------------------
set /p opcion=Selecciona una opcion:

if "%opcion%"=="1" goto listar_conductores_multiples
if "%opcion%"=="2" goto buscar_vehiculos_atributo
if "%opcion%"=="3" goto menu_principal

goto menu_consultas

:listar_conductores_multiples
cls
echo Conductores con mas de un vehiculo asignado:
(for /f "tokens=1 delims=," %%A in (%relaciones_file%) do @echo %%A) | sort | uniq -d > temp_conductores.csv
(for /f "tokens=1 delims=," %%A in (temp_conductores.csv) do findstr /i /c:"%%A" %conductor_file%)
del temp_conductores.csv
pause
goto menu_consultas

:buscar_vehiculos_atributo
cls
set /p atributo=Introduce el atributo o tipo de vehiculo a buscar:
findstr /i /c:"%atributo%" %vehiculo_file%
pause
goto menu_consultas
