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
    echo DNI;Nombre;Apellido;Fecha_Carnet > "%conductor_file%"
)
if not exist "%vehiculo_file%" (
    echo Matricula;Marca;Tipo;Atributo;Valor > "%vehiculo_file%"
)
if not exist "%relaciones_file%" (
    echo DNI -> Matricula > "%relaciones_file%"
)
if not exist "%multas_file%" (
    echo ID;DNI;Matrícula;Descripción;Monto;Estado;Fecha > "%multas_file%"
)

echo.
echo.
echo.
echo.
echo.
echo                                  ================================================
echo                                         --- ATENCIÓN: EDITOR DE PARKING ---
echo                                  ================================================
echo.
echo                                  Por favor, posiciona esta ventana en la pestaña:
echo.
echo.                                         
echo.                                         
echo.                                         
echo.                                         
echo.                                         
echo.                                         
echo                                         I::::::::::::::::::::::::::::::I
echo                                         I                              I
echo                                         I      Editor de parquing      I
echo                                         I                              I
echo                                         I::::::::::::::::::::::::::::::I
echo.
echo                                  ================================================
echo.  
pause

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
echo 6. Reiniciar registro
echo 7. Salir
echo -------------------------------------------
set /p opcion=Selecciona una opcion:

if "%opcion%"=="1" goto menu_conductores
if "%opcion%"=="2" goto menu_vehiculos
if "%opcion%"=="3" goto menu_relaciones
if "%opcion%"=="4" goto menu_multas
if "%opcion%"=="5" goto menu_consultas
if "%opcion%"=="6" (

echo. > control.txt

)
if "%opcion%"=="7" (

echo SALIR >> control.txt
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
echo Introduzca los datos del conductor en el formato: DNI;Nombre;Apellido;Fecha_Carnet
set /p conductor_datos=Datos:
echo %conductor_datos% >> "%conductor_file%"
echo [%date% %time%] =========== Eliminar conductor ========== >> "control.txt"
echo [%date% %time%] ============ Añadir conductor =========== >> "control.txt"
echo       + Datos: %conductor_datos% >> "control.txt"
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
echo DNI;Nombre;Apellido;Fecha_Carnet
for /f "skip=1 tokens=*" %%A in ('type "%conductor_file%"') do (
  if "!current_line!" NEQ "%seleccion%" echo %%A
  set /a current_line+=1
)
) > temp.csv

:: Reemplazar el archivo original
move /y temp.csv "%conductor_file%" > nul


echo [%date% %time%] =========== Eliminar conductor ========== >> "control.txt"
echo       - Eliminado conductor línea %seleccion% >> "control.txt"
echo Conductor eliminado correctamente.
pause
goto menu_conductores

:listar_conductores
cls
echo Lista de conductores:
type "%conductor_file%"
echo [%date% %time%] === Acceder a la lista de conductores === >> "control.txt"
pause
goto menu_conductores

:buscar_conductor
cls
set /p dni=Introduce el DNI del conductor a buscar:
set "dniEncontrado=0"
for /f "usebackq skip=1 tokens=1,2,3,4 delims=;" %%A in ("%conductor_file%") do (
    if "%%A"=="%dni%" (
        set dniEncontrado=1
        echo.
        echo [%date% %time%] ============ Buscar conductor ===========
        echo [%date% %time%] ============ Buscar conductor =========== >> "control.txt"
        echo         + DNI: %%A ^| Nombre: %%B %%C ^| Fecha Carnet: %%D >> "control.txt"
        echo         + DNI: %%A ^| Nombre: %%B %%C ^| Fecha Carnet: %%D
        echo.
    )   
)


if "%dniEncontrado%"=="0" (
    echo [%date% %time%] ============ Buscar conductor ===========
    echo [%date% %time%] ============ Buscar conductor =========== >> "control.txt"
    echo  No se encontró información sobre el DNI: %dni%
    echo  No se encontró información sobre el DNI: %dni% >> "control.txt"
    echo.
)
pause
goto menu_conductores

:actualizar_conductor
cls
set /p dni=Introduce el DNI del conductor a actualizar:
findstr /v /i "%dni%;" "%conductor_file%" > temp.csv
echo.
echo Datos actuales:
echo ----------------------------------------------
findstr /i "%dni%;" "%conductor_file%"
echo ----------------------------------------------
set /p nuevo_datos=Introduce los nuevos datos del conductor (DNI;Nombre;Apellido;Fecha_Carnet):
echo %nuevo_datos% >> temp.csv
move /y temp.csv "%conductor_file%"
echo [%date% %time%] ========== Actualizar conductor ========= >> "control.txt"
echo       ~ Actualizado conductor con DNI: %dni% >> "control.txt"
echo       ~ Actualizado conductor con DNI: %dni%
echo       + Nuevos datos: %nuevo_datos% >> "control.txt"
echo       + Nuevos datos: %nuevo_datos%
echo Conductor actualizado correctamente.
pause
goto menu_conductores

:listar_conductores_antiguedad
cls

:: Obtener la fecha actual en formato AAAA
for /f "usebackq tokens=2 delims==" %%A in (`wmic os get localdatetime /value`) do set "datetime=%%A"
set "year=%datetime:~0,4%"
echo Año actual: %year%

:: Solicitar número mínimo de años
set /p "min_years=Introduce el número mínimo de años de carnet: "

cls
echo ==========================================
echo  CONDUCTORES CON AL MENOS %min_years% AÑOS DE CARNET
echo ==========================================

    echo [%date% %time%] === Buscar conductor con %min_years% años === >> "control.txt"


:: Leer el archivo línea por línea y procesar cada campo
for /f "usebackq skip=1 tokens=1-4 delims=;" %%A in ("%conductor_file%") do (
    set "dni=%%A"
    set "nombre=%%B"
    set "apellido=%%C"
    set "fecha_carnet=%%D"
    
    :: Eliminar espacios en blanco al inicio y final de la fecha
    set "fecha_carnet=!fecha_carnet: =!"
    
    :: Validar que fecha_carnet no esté vacía
    if not "!fecha_carnet!"=="" (
        :: Extraer el año directamente (últimos 4 caracteres de la fecha)
        set "year_carnet=!fecha_carnet:~-4!"
    
        :: Verificar si el año es numérico
        set "is_numeric=true"
        for /f "delims=0123456789" %%i in ("!year_carnet!") do set "is_numeric=false"
        
        if "!is_numeric!"=="true" (
            :: Calcular años de carnet
            set /a "years_carnet=%year% - !year_carnet!"
                    

            :: Comparar años de carnet con el mínimo requerido
            if !years_carnet! GEQ %min_years% (
                :: Imprimir en pantalla y guardar en archivo
                echo          -  DNI: %%A ^| Fecha Carnet: %%D ^[!years_carnet!^] años ^| Nombre: %%B %%C
                echo          -  DNI: %%A ^| Fecha Carnet: %%D ^[!years_carnet!^] años ^| Nombre: %%B %%C >> "control.txt"

            )
        ) else (
            echo          x  [ERROR] Fecha inválida para el conductor: !dni! - !nombre! !apellido! (!fecha_carnet!)
        )
    )
)

echo ==========================================
echo.
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
echo Introduzca los datos del vehiculo en el formato: Matricula;Marca;Tipo;Atributo;Valor
set /p vehiculo_datos=Datos:
echo %vehiculo_datos% >> "%vehiculo_file%"
echo [%date% %time%] ============ Anadir vehiculo ============ >> "control.txt"
echo       + Datos: %vehiculo_datos% >> "control.txt"
echo.
echo [%date% %time%] ============ Anadir vehiculo ============
echo       + Datos: %vehiculo_datos%
pause
goto menu_vehiculos

:eliminar_vehiculo
cls
set /p matricula=Introduce la matricula del vehiculo a eliminar:
findstr /v /i "%matricula%;" "%vehiculo_file%" > temp.csv
move /y temp.csv "%vehiculo_file%"
echo [%date% %time%] ============ Eliminar vehiculo ========== >> "control.txt"
echo       - Eliminado vehiculo con matricula: %matricula% >> "control.txt"
echo.
echo [%date% %time%] ============ Eliminar vehiculo ==========
echo       - Eliminado vehiculo con matricula: %matricula%
echo Vehiculo eliminado correctamente.
pause
goto menu_vehiculos

:listar_vehiculos
cls
echo Lista de vehiculos:
type "%vehiculo_file%"
echo [%date% %time%] ==== Acceder a la lista de vehiculos ==== >> "control.txt"
echo.
echo [%date% %time%] ==== Acceder a la lista de vehiculos ====
pause
goto menu_vehiculos

:buscar_vehiculo
cls
set /p VEHICULO_MATRICULA=Introduce la matricula del vehiculo a buscar:
set "VEHICULO_ENCONTRADO=0"

for /f "usebackq skip=1 tokens=1,2,3,4,5 delims=;" %%A in ("%vehiculo_file%") do (
    if "%%A"=="%VEHICULO_MATRICULA%" (
        set "VEHICULO_ENCONTRADO=1"  :: Marca que se encontró el vehículo
            echo [%date% %time%] ============ Buscar vehiculo ============ >> "control.txt"
            echo       - Encontrado vehiculo con matricula: %VEHICULO_MATRICULA% >> "control.txt"
            echo         + %%C : %%B ^(%%A^) ^[%%D: %%E^] >> "control.txt"
            echo.
            echo [%date% %time%] ============ Buscar vehiculo ============
            echo       - Encontrado vehiculo con matricula: %VEHICULO_MATRICULA%
            echo         + %%C : %%B ^(%%A^) ^[%%D: %%E^]
    )
)

if "%VEHICULO_ENCONTRADO%"=="0" (
    echo [%date% %time%] ============ Buscar vehiculo ============ >> "control.txt"
    echo      x No se encontro el vehiculo con matricula: %VEHICULO_MATRICULA% >> "control.txt"
    echo.
    echo [%date% %time%] ============ Buscar vehiculo ============
    echo      x No se encontro el vehiculo con matricula: %VEHICULO_MATRICULA%
)
pause
goto menu_vehiculos

:actualizar_vehiculo
cls
set /p matricula=Introduce la matricula del vehiculo a actualizar:
findstr /v /i "%matricula%;" "%vehiculo_file%" > temp.csv
echo.
echo Datos actuales:
echo ----------------------------------------------
findstr /i "%matricula%;" "%vehiculo_file%"
echo ----------------------------------------------
set /p nuevo_datos=Introduce los nuevos datos del vehiculo (Matricula;Marca;Tipo;Atributo;Valor):
echo %nuevo_datos% >> temp.csv
move /y temp.csv "%vehiculo_file%"
echo [%date% %time%] ========== Actualizar vehiculo ========== >> "control.txt"
echo       ~ Actualizado vehiculo con matricula: %matricula% >> "control.txt"
echo       + Nuevos datos: %nuevo_datos% >> "control.txt"
echo.
echo [%date% %time%] ========== Actualizar vehiculo ========== 
echo       ~ Actualizado vehiculo con matricula: %matricula% 
echo       + Nuevos datos: %nuevo_datos% 
echo Vehiculo actualizado correctamente.
pause
goto menu_vehiculos

:listar_vehiculos_tipo
cls
set "VEHICULO_TIPO=0"

set /p Tipo=Introduce el tipo de vehiculo a buscar:

echo [%date% %time%] ============ Buscar vehiculo %Tipo% ============
echo [%date% %time%] ====== Buscar vehiculo %Tipo% ======= >> "control.txt"

for /f "usebackq skip=1 tokens=1,2,3,4,5 delims=;" %%A in ("%vehiculo_file%") do (
    if "%%C"=="%Tipo%" (
        set "VEHICULO_TIPO=1"  :: Marca que se encontró el vehículo
            echo         + %%C : ^(%%A^) ^[%%D: %%E^] %%B >> "control.txt"
            echo         + %%C : ^(%%A^) ^[%%D: %%E^] %%B
    )
)

if "%VEHICULO_TIPO%"=="0" (
    echo       x No se encontro el vehiculo tipo: %Tipo% >> "control.txt"
    echo       x No se encontro el vehiculo tipo: %Tipo%
)
pause
goto menu_vehiculos

:listar_vehiculos_marca
cls
set "VEHICULO_MARCA=0"

set /p marca=Introduce la marca del vehiculo a buscar:

echo [%date% %time%] ============ Buscar marca %Tipo% ============
echo [%date% %time%] ====== Buscar marca %Tipo% ======= >> "control.txt"

for /f "usebackq skip=1 tokens=1,2,3,4,5 delims=;" %%A in ("%vehiculo_file%") do (
    if "%%B"=="%marca%" (
        set "VEHICULO_MARCA=1"  :: Marca que se encontró el vehículo
            echo         + %%C : ^(%%A^) ^[%%D: %%E^] %%B >> "control.txt"
            echo         + %%C : ^(%%A^) ^[%%D: %%E^] %%B
    )
)

if "%VEHICULO_MARCA%"=="0" (
    echo       x No se encontro el vehiculo de la marca: %marca% >> "control.txt"
    echo       x No se encontro el vehiculo de la marca: %marca%
)
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
echo Introduzca los datos de la relacion en el formato: DNI;Matricula
set /p relacion_datos=Datos:
echo %relacion_datos% >> "%relaciones_file%"
echo [%date% %time%] =========== Asignar relacion ========== >> "control.txt"
echo       + Relacion asignada: %relacion_datos% >> "control.txt"
echo.
echo [%date% %time%] =========== Asignar relacion ==========
echo       + Relacion asignada: %relacion_datos%
echo Relacion asignada correctamente.
pause
goto menu_relaciones

:eliminar_relacion
cls
set /p filtro=Introduce el DNI o la Matricula para eliminar la relacion:
findstr /v /i "%filtro%" "%relaciones_file%" > temp.csv
move /y temp.csv "%relaciones_file%"
echo [%date% %time%] =========== Eliminar relacion ========== >> "control.txt"
echo       - Eliminada relacion con filtro: %filtro% >> "control.txt"
echo.
echo [%date% %time%] =========== Eliminar relacion ==========
echo       - Eliminada relacion con filtro: %filtro%
echo Relacion eliminada correctamente.
pause
goto menu_relaciones

:listar_relaciones
cls
echo Lista de relaciones existentes:
type "%relaciones_file%"
echo [%date% %time%] === Acceder a la lista de relaciones === >> "control.txt"
echo.
echo [%date% %time%] === Acceder a la lista de relaciones ===
pause
goto menu_relaciones

:buscar_relacion
cls
set /p filtro=Introduce el DNI o la Matrícula a buscar:

:: Inicializar variables
set relacionEncontrada=0
set conductorDatos=
set vehiculoDatos=

:: Buscar en el archivo de relaciones
for /f "usebackq skip=1 tokens=1,2 delims=;" %%A in ("%relaciones_file%") do (
    if "%%A"=="%filtro%" (
        set relacionEncontrada=1
        set conductorFiltro=%%A
        set matriculaFiltro=%%B
    ) else if "%%B"=="%filtro%" (
        set relacionEncontrada=1
        set conductorFiltro=%%A
        set matriculaFiltro=%%B
    )
)

:: Si se encontró la relación, buscar los datos del conductor y del vehículo
if "%relacionEncontrada%"=="1" (
    :: Buscar datos del conductor
    for /f "usebackq skip=1 tokens=1,2,3,4 delims=;" %%A in ("%conductor_file%") do (
        if "%%A"=="%conductorFiltro%" (
            echo [%date% %time%] ============ Buscar relación ===========
            echo [%date% %time%] ============ Buscar relación =========== >> "control.txt"
            echo         + DNI: %%A ^| Nombre: %%B %%C ^| Fecha Carnet: %%D >> "control.txt"
            echo         + DNI: %%A ^| Nombre: %%B %%C ^| Fecha Carnet: %%D
        )
    )

    :: Buscar datos del vehículo
    for /f "usebackq skip=1 tokens=1,2,3,4,5 delims=;" %%A in ("%vehiculo_file%") do (
        if "%%A"=="%matriculaFiltro%" (
            echo         + %%C : ^(%%A^) ^[%%D: %%E^] %%B >> "control.txt"
            echo         + %%C : ^(%%A^) ^[%%D: %%E^] %%B
        )
    )

) else (
    :: No se encontró ninguna relación
    echo [%date% %time%] ============ Buscar relación ===========
    echo [%date% %time%] ============ Buscar relación =========== >> "control.txt"
    echo x [ERROR] No se encontró ninguna relación con el filtro: %filtro%
    echo x [ERROR] No se encontró ninguna relación con el filtro: %filtro% >> "control.txt"
)

pause
goto menu_relaciones

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
(for /f "tokens=1 delims=;" %%A in ("%relaciones_file%") do (
  findstr /c:"%%A" "%relaciones_file%" > nul
  if !errorlevel! gtr 1 echo %%A
)) | sort | uniq
echo [%date% %time%] ====== Listar conductores con varios vehiculos ====== >> "control.txt"
echo       > Consultada lista de conductores con mas de un vehiculo. >> "control.txt"
echo.
echo [%date% %time%] ====== Listar conductores con varios vehiculos ======
echo       > Consultada lista de conductores con mas de un vehiculo.
pause
goto menu_consultas

:listar_vehiculos_por_conductor
cls
set /p dni=Introduce el DNI del conductor:
echo Vehiculos asignados al conductor %dni%:
findstr /i "%dni%" "%relaciones_file%" > temp.csv
for /f "tokens=2 delims=;" %%B in (temp.csv) do (
  findstr /i "%%B" "%vehiculo_file%"
)
del temp.csv
echo [%date% %time%] ====== Listar vehiculos por conductor ====== >> "control.txt"
echo       > Vehiculos asignados al conductor con DNI: %dni% >> "control.txt"
echo.
echo [%date% %time%] ====== Listar vehiculos por conductor ======
echo       > Vehiculos asignados al conductor con DNI: %dni%
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
echo Introduzca los datos de la multa en el formato: ID;DNI;Matrícula;Descripción;Monto;Estado;Fecha
set /p multa_datos=Datos:
echo %multa_datos% >> "%multas_file%"
echo.
(
    echo [%date% %time%] ============ Anadir multa ============
    echo       + Datos: %multa_datos%

) >> "control.txt"
echo [%date% %time%] ============ Anadir multa ============
echo       + Datos: %multa_datos%
echo.
echo Multa añadida correctamente.
pause
goto menu_multas

:eliminar_multa
cls
set /p id=Introduce el ID de la multa a eliminar:
findstr /v /i "%id%;" "%multas_file%" > temp.csv
move /y temp.csv "%multas_file%"
(
    echo [%date% %time%] ============ Eliminar multa ============
    echo       - Multa con ID: %id% eliminada
    echo.
) >> "control.txt"
echo [%date% %time%] ============ Eliminar multa ============
echo       - Multa con ID: %id% eliminada
echo.
echo Multa eliminada correctamente.
pause
goto menu_multas

:listar_multas
cls
echo Lista de multas:
type "%multas_file%"
(
    echo [%date% %time%] ==== Acceder a la lista de multas ==== 
    echo.
) >> "control.txt"
echo [%date% %time%] ==== Acceder a la lista de multas ==== 
echo.
pause
goto menu_multas

:buscar_multa
cls
set "MULTA_ID=0"

set /p id=Introduce el ID de la multa a buscar:

echo [%date% %time%] ============ Buscar multa %id% ============
echo [%date% %time%] ===== Buscar multa ID %id% ===== >> "control.txt"

for /f "usebackq skip=1 tokens=1,2,3,4,5,6,7 delims=;" %%A in ("%multas_file%") do (

    if "%%A"=="%id%" (
        set "MULTA_ID=1"
            echo         + Multa %%A : ^(%%E€^) **^[%%F^]** - %%G ^| "%%D"
    )
)

    if "%MULTA_ID%"=="0" (
        echo       x No se encontro la multa con el ID: %id% >> "control.txt"
        echo       x No se encontro la multa con el ID: %id%
    )
pause
goto menu_multas

:actualizar_multa
cls
set /p id=Introduce el ID de la multa a actualizar:
findstr /v /i "%id%;" "%multas_file%" > temp.csv
echo.
echo Datos actuales:
echo ----------------------------------------------
findstr /i "%id%;" "%multas_file%"
echo ----------------------------------------------
set /p nuevo_datos=Introduce los nuevos datos de la multa (ID;DNI;Matrícula;Descripción;Monto;Estado;Fecha):
echo %nuevo_datos% >> temp.csv
move /y temp.csv "%multas_file%"
(
    echo [%date% %time%] ============ Actualizar multa ============
    echo       * Multa actualizada: %nuevo_datos%
    echo.
) >> "control.txt"
echo [%date% %time%] ============ Actualizar multa ============
echo       * Multa actualizada: %nuevo_datos%
echo.
echo Multa actualizada correctamente.
pause
goto menu_multas

