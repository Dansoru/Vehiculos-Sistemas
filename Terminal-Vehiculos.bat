@echo off
cls
setlocal enabledelayedexpansion

:: Definir las rutas de los archivos de datos
set conductor_file=conductores.txt
set vehiculo_file=vehiculos.txt
set relaciones_file=relaciones.txt

:menu_principal
cls
echo -------------------------------------------
echo Terminal de Gestion de Vehiculos
echo -------------------------------------------
echo 1. Gestion de Conductores
echo 2. Gestion de Vehiculos
echo 3. Gestion de Relaciones (Conductor-Vehiculo)
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
echo Gestion de Conductores
echo -------------------------------------------
echo 1. Anadir conductor
echo 2. Eliminar conductor
echo 3. Listar conductores
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
echo Introduzca los datos del conductor (DNI, Nombre, Apellido, Fecha_Carnet):
set /p conductor_datos=Datos:
echo %conductor_datos% >> %conductor_file%
echo Conductor anadido correctamente.
pause
goto menu_conductores

:eliminar_conductor
cls
set /p dni=Introduce el DNI del conductor a eliminar:
findstr /v /i "%dni%" %conductor_file% > temp.txt
move /y temp.txt %conductor_file%
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
findstr /i "%dni%" %conductor_file%
pause
goto menu_conductores

:actualizar_conductor
cls
set /p dni=Introduce el DNI del conductor a actualizar:
findstr /v /i "%dni%" %conductor_file% > temp.txt
set /p nuevo_datos=Introduce los nuevos datos del conductor (DNI, Nombre, Apellido, Fecha_Carnet):
echo %nuevo_datos% >> %conductor_file%
move /y temp.txt %conductor_file%
echo Conductor actualizado correctamente.
pause
goto menu_conductores

:listar_conductores_antiguedad
cls
set /p anos_min=Introduce los anos minimos de carnet:
echo Conductores con mas de %anos_min% anos de carnet:
for /f "tokens=4 delims=," %%a in (%conductor_file%) do (
    set /a anos=%%a
    if !anos! geq %anos_min% echo %%a
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

goto menu_vehiculos

:: Funciones de vehiculos
:anadir_vehiculo
cls
echo Introduzca los datos del vehiculo (Matricula, Marca, Tipo, Atributo, Valor):
set /p vehiculo_datos=Datos:
echo %vehiculo_datos% >> %vehiculo_file%
echo Vehiculo anadido correctamente.
pause
goto menu_vehiculos

:eliminar_vehiculo
cls
set /p matricula=Introduce la matricula del vehiculo a eliminar:
findstr /v /i "%matricula%" %vehiculo_file% > temp.txt
move /y temp.txt %vehiculo_file%
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
findstr /i "%matricula%" %vehiculo_file%
pause
goto menu_vehiculos

:actualizar_vehiculo
cls
set /p matricula=Introduce la matricula del vehiculo a actualizar:
findstr /v /i "%matricula%" %vehiculo_file% > temp.txt
set /p nuevo_datos=Introduce los nuevos datos del vehiculo (Matricula, Marca, Tipo, Atributo, Valor):
echo %nuevo_datos% >> %vehiculo_file%
move /y temp.txt %vehiculo_file%
echo Vehiculo actualizado correctamente.
pause
goto menu_vehiculos

:listar_vehiculos_tipo
cls
set /p tipo=Introduce el tipo de vehiculo (Coche, Moto, Camion):
for /f "tokens=2,3,4,5 delims=," %%a in (%vehiculo_file%) do (
    if "%%c"=="%tipo%" echo %%a, %%b, %%c, %%d, %%e
)
pause
goto menu_vehiculos

:listar_vehiculos_marca
cls
set /p marca=Introduce la marca de los vehiculos:
for /f "tokens=2,3,4,5 delims=," %%a in (%vehiculo_file%) do (
    if "%%b"=="%marca%" echo %%a, %%b, %%c, %%d, %%e
)
pause
goto menu_vehiculos

:listar_vehiculos_sin_conductor
cls
echo Vehiculos sin conductor asignado:
for /f "tokens=1,2 delims=," %%a in (%vehiculo_file%) do (
    findstr /i "%%a" %conductor_file% >nul
    if errorlevel 1 echo %%a
)
pause
goto menu_vehiculos

:menu_relaciones
cls
echo -------------------------------------------
echo Gestion de Relaciones (Conductor-Vehiculo)
echo -------------------------------------------
echo 1. Asignar vehiculo a conductor
echo 2. Eliminar vehiculo de conductor
echo 3. Consultar vehiculos de un conductor
echo 4. Consultar conductores de un vehiculo
echo 5. Regresar al menu principal
echo -------------------------------------------
set /p opcion=Selecciona una opcion:

if "%opcion%"=="1" goto asignar_vehiculo_conductor
if "%opcion%"=="2" goto eliminar_vehiculo_conductor
if "%opcion%"=="3" goto consultar_vehiculos_conductor
if "%opcion%"=="4" goto consultar_conductores_vehiculo
if "%opcion%"=="5" goto menu_principal

goto menu_relaciones

:: Funciones de relaciones
:asignar_vehiculo_conductor
cls
set /p dni=Introduce el DNI del conductor:
set /p matricula=Introduce la matricula del vehiculo:
echo %dni% -> %matricula% >> %relaciones_file%
echo Vehiculo asignado correctamente.
pause
goto menu_relaciones

:eliminar_vehiculo_conductor
cls
set /p dni=Introduce el DNI del conductor:
set /p matricula=Introduce la matricula del vehiculo:
findstr /v /i "%dni% -> %matricula%" %relaciones_file% > temp.txt
move /y temp.txt %relaciones_file%
echo Relacion eliminada correctamente.
pause
goto menu_relaciones

:consultar_vehiculos_conductor
cls
set /p dni=Introduce el DNI del conductor:
echo Vehiculos asignados al conductor:
findstr /i "%dni%" %relaciones_file%
pause
goto menu_relaciones

:consultar_conductores_vehiculo
cls
set /p matricula=Introduce la matricula del vehiculo:
echo Conductores asignados a este vehiculo:
findstr /i "%matricula%" %relaciones_file%
pause
goto menu_relaciones

:menu_consultas
cls
echo -------------------------------------------
echo Consultas Especiales
echo -------------------------------------------
echo 1. Consultar vehiculos por tipo
echo 2. Consultar vehiculos de una marca
echo 3. Consultar conductores con mas de X anos de carnet
echo 4. Regresar al menu principal
echo -------------------------------------------
set /p opcion=Selecciona una opcion:

if "%opcion%"=="1" goto consultar_vehiculos_tipo
if "%opcion%"=="2" goto consultar_vehiculos_marca
if "%opcion%"=="3" goto consultar_conductores_anos
if "%opcion%"=="4" goto menu_principal

goto menu_consultas

:: Funciones de consultas especiales
:consultar_vehiculos_tipo
cls
set /p tipo=Introduce el tipo de vehiculo (Coche, Moto, Camion):
for /f "tokens=2,3,4,5 delims=," %%a in (%vehiculo_file%) do (
    if "%%c"=="%tipo%" echo %%a, %%b, %%c, %%d, %%e
)
pause
goto menu_consultas

:consultar_vehiculos_marca
cls
set /p marca=Introduce la marca de los vehiculos:
for /f "tokens=2,3,4,5 delims=," %%a in (%vehiculo_file%) do (
    if "%%b"=="%marca%" echo %%a, %%b, %%c, %%d, %%e
)
pause
goto menu_consultas

:consultar_conductores_anos
cls
set /p anos_min=Introduce los anos minimos de carnet:
for /f "tokens=4 delims=," %%a in (%conductor_file%) do (
    set /a anos=%%a
    if !anos! geq %anos_min% echo %%a
)
pause
goto menu_consultas
