@echo off
setlocal EnableDelayedExpansion
title Monitor de Parking

powershell -command "Add-Type -TypeDefinition 'using System;using System.Runtime.InteropServices;public class Window {[DllImport(\"user32.dll\")] public static extern bool MoveWindow(IntPtr hWnd, int X, int Y, int nWidth, int nHeight, bool bRepaint);}'"

:inicio
cls
echo === MONITOR DE PARKING ===
echo.
type "%conductor_file%"
echo.
type "%vehiculo_file%"
echo.
type "%relaciones_file%"
echo.
type "%multas_file%"
timeout /t 2 /nobreak >nul
goto inicio