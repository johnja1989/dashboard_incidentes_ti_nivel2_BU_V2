@echo off
chcp 65001 >nul 2>&1
title Dashboard Sync - Banco Union S.A.
color 0A

echo.
echo  ══════════════════════════════════════════════════════════
echo  ║  SINCRONIZACION DASHBOARD INCIDENTES TI               ║
echo  ║  Banco Union S.A. - Vicepresidencia de Tecnologia     ║
echo  ══════════════════════════════════════════════════════════
echo.

:: Buscar el Excel más reciente en Downloads
set "EXCEL_FILE="
for /f "delims=" %%F in ('powershell -NoProfile -Command "Get-ChildItem \"$env:USERPROFILE\Downloads\" -Filter \"EST_VPT_BackLog_Incidentes*.xlsx\" -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1 -ExpandProperty FullName"') do set "EXCEL_FILE=%%F"

if "%EXCEL_FILE%"=="" (
    echo  [!] No se encontro el archivo Excel en Downloads.
    echo.
    echo  INSTRUCCIONES:
    echo  1. Abre SharePoint en tu navegador
    echo  2. Descarga el archivo EST_VPT_BackLog_Incidentes_BU_V001_20250812.xlsx
    echo  3. Guardalo en tu carpeta de Downloads
    echo  4. Ejecuta este archivo nuevamente
    echo.
    pause
    exit /b 1
)

echo  [OK] Excel encontrado: %EXCEL_FILE%
echo.
echo  Procesando... por favor espera...
echo.

:: Ejecutar el script PowerShell
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync_dashboard.ps1" -ExcelPath "%EXCEL_FILE%" -Force

echo.
if %ERRORLEVEL%==0 (
    color 0A
    echo  ══════════════════════════════════════════════════════════
    echo  ║  SINCRONIZACION EXITOSA                                ║
    echo  ║  El dashboard se actualizara en 1-3 minutos            ║
    echo  ║  https://johnja1989.github.io/dashboard_incidentes_ti_nivel2_BU_V2/
    echo  ══════════════════════════════════════════════════════════
) else (
    color 0C
    echo  ══════════════════════════════════════════════════════════
    echo  ║  ERROR EN LA SINCRONIZACION                            ║
    echo  ║  Revisa el log: sync_dashboard.log                     ║
    echo  ══════════════════════════════════════════════════════════
)

echo.
pause
