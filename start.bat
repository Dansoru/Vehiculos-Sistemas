@echo off
cd %~dp0

chcp 65001 > nul

echo.
echo.
echo  ░▒▓███████▓▒░ ░▒▓█▓▒░  ░▒▓███████▓▒░ ░▒▓████████▓▒░ ░▒▓████████▓▒░ ░▒▓██████████████▓▒░   ░▒▓██████▓▒░   ░▒▓███████▓▒░ 
echo ░▒▓█▓▒░        ░▒▓█▓▒░ ░▒▓█▓▒░           ░▒▓█▓▒░     ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░        
echo ░▒▓█▓▒░        ░▒▓█▓▒░ ░▒▓█▓▒░           ░▒▓█▓▒░     ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░        
echo  ░▒▓██████▓▒░  ░▒▓█▓▒░  ░▒▓██████▓▒░     ░▒▓█▓▒░     ░▒▓██████▓▒░   ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ░▒▓████████▓▒░  ░▒▓██████▓▒░  
echo        ░▒▓█▓▒░ ░▒▓█▓▒░        ░▒▓█▓▒░    ░▒▓█▓▒░     ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░        ░▒▓█▓▒░ 
echo        ░▒▓█▓▒░ ░▒▓█▓▒░        ░▒▓█▓▒░    ░▒▓█▓▒░     ░▒▓█▓▒░        ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░        ░▒▓█▓▒░ 
echo ░▒▓███████▓▒░  ░▒▓█▓▒░ ░▒▓███████▓▒░     ░▒▓█▓▒░     ░▒▓████████▓▒░ ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░ ░▒▓█▓▒░░▒▓█▓▒░ ░▒▓███████▓▒░  
echo.
echo.
echo                RRRRRRRRRRRRRRRR        OOOOOOOO     MMMMMMM               MMMMMMM     OOOOOOOO     
echo                R:::::::::::::::R     OO::::::::OO   M::::::M             M::::::M   OO::::::::OO   
echo                R::::::RRRRR:::::R  OO::::::::::::OO M:::::::M           M:::::::M OO::::::::::::OO 
echo                RR:::::R    R:::::RO:::::::OO:::::::OM::::::::M         M::::::::MO:::::::OO:::::::O
echo                  R::::R    R:::::RO::::::O  O::::::OM:::::::::M       M:::::::::MO::::::O  O::::::O
echo                  R::::R    R:::::RO:::::O    O:::::OM::::::::::M     M::::::::::MO:::::O    O:::::O
echo                  R::::RRRRR:::::R O:::::O    O:::::OM::::::M::::M   M::::M::::::MO:::::O    O:::::O
echo                  R::::RRRRR:::::R O:::::O    O:::::OM:::::M  M::::M::::M  M:::::MO:::::O    O:::::O
echo                  R::::R    R:::::RO::::::O  O::::::OM:::::M     MMMMM     M:::::MO::::::O  O::::::O
echo                RR:::::R    R:::::RO:::::::OO:::::::OM:::::M               M:::::MO:::::::OO:::::::O
echo                R::::::R    R:::::R OO::::::::::::OO M:::::M               M:::::M OO::::::::::::OO 
echo                R::::::R    R:::::R   OO::::::::OO   M:::::M               M:::::M   OO::::::::OO   
echo                RRRRRRRR    RRRRRRR     OOOOOOOO     MMMMMMM               MMMMMMM     OOOOOOOO     
echo.
echo.
echo                                                    Bienvenido       
echo.                                                                                                                                  
pause
echo.
echo.
echo.
echo.
echo.
echo                                  ================================================
echo                                                 --- IMPORTANTE ---
echo                                  ================================================
echo.                                 
echo                                  Cierra todas las ventanas abiertas EXCEPTO .CMD
echo.                                 
echo                                  ================================================
echo.
echo                                   Recuerda posicionar correctamente las pestañas.
echo.
echo.
echo                                         I::::::::::::::::::::::::::::::I
echo                                         I                              I
echo                                         I                              I
echo                                         I      Monitor de parquing     I
echo                                         I                              I
echo                                         I                              I
echo                                         I::::::::::::::::::::::::::::::I
echo                                         I                              I
echo                                         I      Editor de parquing      I
echo                                         I                              I
echo                                         I::::::::::::::::::::::::::::::I
echo.
echo.
echo.
pause

REM Crear archivo VBS temporal
echo Set Shell = CreateObject("Shell.Application") > "%temp%\arrange.vbs"
echo Set WS = CreateObject("WScript.Shell") >> "%temp%\arrange.vbs"
echo WScript.Sleep 500 >> "%temp%\arrange.vbs"
echo Shell.TileHorizontally >> "%temp%\arrange.vbs"

REM Lanzar las ventanas con tamaño específico
start "Editor de Parking" cmd /k mode con cols=85 lines=40 ^& color 0f ^& editor.bat
timeout /t 1 /nobreak >nul
start "Monitor de Parking" cmd /k mode con cols=85 lines=40 ^& color 0f ^& monitor.bat
timeout /t 1 /nobreak >nul

REM Ejecutar script VBS y limpiarlo
cscript //nologo "%temp%\arrange.vbs"
del "%temp%\arrange.vbs"
exit