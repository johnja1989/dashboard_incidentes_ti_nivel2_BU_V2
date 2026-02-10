###############################################################################
# sync_dashboard.ps1 — Sincronización Automática: SharePoint Excel → GitHub
# Dashboard Backlog Incidentes TI — Banco Unión S.A.
#
# Este script:
#   1. Lee el archivo Excel desde tu carpeta de OneDrive sincronizada
#   2. Extrae la pestaña "Backlog Incidentes TI"
#   3. Convierte a CSV
#   4. Crea un ZIP (datos.zip)
#   5. Lo sube a GitHub via API
#
# USO:
#   .\sync_dashboard.ps1                           → Ejecución normal
#   .\sync_dashboard.ps1 -ExcelPath "C:\ruta.xlsx" → Ruta personalizada
#   .\sync_dashboard.ps1 -Force                    → Fuerza subida aunque no haya cambios
#
# REQUISITOS:
#   - PowerShell 5.1+ (incluido en Windows 10/11)
#   - Módulo ImportExcel: Install-Module ImportExcel -Scope CurrentUser
#   - Carpeta OneDrive sincronizada con el archivo Excel
#   - GitHub Personal Access Token (PAT) con permisos "repo"
#
# PROGRAMAR EJECUCIÓN AUTOMÁTICA:
#   Ver sección al final del script o ejecutar:
#   .\sync_dashboard.ps1 -InstallScheduledTask
###############################################################################

[CmdletBinding()]
param(
    # Ruta al archivo Excel (si no se da, busca en OneDrive automáticamente)
    [string]$ExcelPath = "",

    # Nombre de la pestaña/hoja del Excel a exportar
    [string]$SheetName = "Backlog Incidentes TI",

    # GitHub config
    [string]$GitHubUser = "johnja1989",
    [string]$GitHubRepo = "dashboard_incidentes_ti_nivel2_BU_V2",
    [string]$GitHubBranch = "main",
    [string]$GitHubFile = "datos.zip",

    # GitHub PAT (si no se da, busca en variable de entorno o archivo)
    [string]$GitHubPAT = "",

    # Forzar subida aunque no haya cambios
    [switch]$Force,

    # Instalar tarea programada en Windows
    [switch]$InstallScheduledTask,

    # Desinstalar tarea programada
    [switch]$UninstallScheduledTask,

    # Intervalo en minutos para la tarea programada (default: 30 min)
    [int]$IntervalMinutes = 30
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$logFile = Join-Path $scriptDir "sync_dashboard.log"
$hashFile = Join-Path $scriptDir ".last_excel_hash"
$patFile = Join-Path $scriptDir ".github_pat"

###############################################################################
# FUNCIONES DE UTILIDAD
###############################################################################

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $entry = "[$timestamp] [$Level] $Message"
    Write-Host $entry -ForegroundColor $(switch ($Level) {
        "ERROR"   { "Red" }
        "WARN"    { "Yellow" }
        "SUCCESS" { "Green" }
        default   { "Cyan" }
    })
    Add-Content -Path $logFile -Value $entry -Encoding UTF8
}

function Get-FileHash256 {
    param([string]$Path)
    return (Get-FileHash -Path $Path -Algorithm SHA256).Hash
}

function Get-GitHubPAT {
    # Prioridad: parámetro > variable de entorno > archivo local
    if ($GitHubPAT) { return $GitHubPAT }

    $envPat = $env:DASHBOARD_GITHUB_PAT
    if ($envPat) {
        Write-Log "PAT obtenido de variable de entorno DASHBOARD_GITHUB_PAT"
        return $envPat
    }

    if (Test-Path $patFile) {
        $filePat = (Get-Content $patFile -Raw).Trim()
        if ($filePat) {
            Write-Log "PAT obtenido de archivo .github_pat"
            return $filePat
        }
    }

    return $null
}

function Find-ExcelFile {
    # Buscar el archivo Excel en las ubicaciones típicas de OneDrive sincronizado
    $possibleNames = @(
        "EST_VPT_BackLog_Incidentes_BU_V001_20250812.xlsx",
        "EST_VPT_BackLog_Incidentes_BU_V001*.xlsx",
        "EST_VPT_BackLog_Incidentes*.xlsx"
    )

    # Ubicaciones de OneDrive comunes
    $oneDrivePaths = @()

    # OneDrive Business
    $regPaths = @(
        "HKCU:\Software\Microsoft\OneDrive\Accounts\Business1",
        "HKCU:\Software\Microsoft\OneDrive\Accounts\Business2"
    )
    foreach ($rp in $regPaths) {
        if (Test-Path $rp) {
            $userFolder = (Get-ItemProperty $rp -ErrorAction SilentlyContinue).UserFolder
            if ($userFolder) { $oneDrivePaths += $userFolder }
        }
    }

    # Rutas por defecto
    $oneDrivePaths += @(
        "$env:USERPROFILE\OneDrive - *",
        "$env:USERPROFILE\OneDrive",
        "$env:OneDriveCommercial",
        "$env:OneDrive"
    )

    # Resolver wildcards
    $resolvedPaths = @()
    foreach ($p in $oneDrivePaths) {
        if ($p) {
            $resolved = Resolve-Path $p -ErrorAction SilentlyContinue
            if ($resolved) { $resolvedPaths += $resolved.Path }
        }
    }

    Write-Log "Buscando Excel en OneDrive: $($resolvedPaths.Count) carpetas base encontradas"

    foreach ($basePath in $resolvedPaths) {
        foreach ($pattern in $possibleNames) {
            $found = Get-ChildItem -Path $basePath -Filter $pattern -Recurse -File -ErrorAction SilentlyContinue |
                     Sort-Object LastWriteTime -Descending |
                     Select-Object -First 1
            if ($found) {
                Write-Log "Excel encontrado: $($found.FullName)"
                return $found.FullName
            }
        }
    }

    return $null
}

###############################################################################
# TAREA PROGRAMADA
###############################################################################

function Install-SyncTask {
    $taskName = "DashboardIncidentesTI_Sync"
    $scriptPath = $MyInvocation.ScriptName
    if (-not $scriptPath) { $scriptPath = Join-Path $scriptDir "sync_dashboard.ps1" }

    Write-Log "Instalando tarea programada '$taskName' cada $IntervalMinutes min..."

    $action = New-ScheduledTaskAction `
        -Execute "powershell.exe" `
        -Argument "-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File `"$scriptPath`""

    $trigger = New-ScheduledTaskTrigger -Once -At (Get-Date) `
        -RepetitionInterval (New-TimeSpan -Minutes $IntervalMinutes) `
        -RepetitionDuration (New-TimeSpan -Days 365)

    $settings = New-ScheduledTaskSettingsSet `
        -AllowStartIfOnBatteries `
        -DontStopIfGoingOnBatteries `
        -StartWhenAvailable `
        -RunOnlyIfNetworkAvailable

    $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited

    Register-ScheduledTask `
        -TaskName $taskName `
        -Action $action `
        -Trigger $trigger `
        -Settings $settings `
        -Principal $principal `
        -Description "Sincroniza el Excel de Backlog Incidentes TI desde OneDrive al Dashboard en GitHub" `
        -Force

    Write-Log "Tarea programada instalada. Se ejecutará cada $IntervalMinutes minutos." "SUCCESS"
    Write-Host ""
    Write-Host "=================================================" -ForegroundColor Green
    Write-Host "  TAREA PROGRAMADA INSTALADA EXITOSAMENTE" -ForegroundColor Green
    Write-Host "  Nombre: $taskName" -ForegroundColor Green
    Write-Host "  Intervalo: Cada $IntervalMinutes minutos" -ForegroundColor Green
    Write-Host "  Administrar: taskschd.msc" -ForegroundColor Green
    Write-Host "=================================================" -ForegroundColor Green
}

function Uninstall-SyncTask {
    $taskName = "DashboardIncidentesTI_Sync"
    Unregister-ScheduledTask -TaskName $taskName -Confirm:$false -ErrorAction SilentlyContinue
    Write-Log "Tarea programada '$taskName' eliminada." "SUCCESS"
}

###############################################################################
# PROCESO PRINCIPAL
###############################################################################

function Invoke-Sync {
    Write-Log "======== INICIO DE SINCRONIZACIÓN ========"

    # --- 1. Verificar módulo ImportExcel ---
    if (-not (Get-Module -ListAvailable -Name ImportExcel)) {
        Write-Log "Módulo ImportExcel no encontrado. Instalando..." "WARN"
        try {
            Install-Module ImportExcel -Scope CurrentUser -Force -AllowClobber
            Write-Log "Módulo ImportExcel instalado correctamente." "SUCCESS"
        }
        catch {
            Write-Log "ERROR: No se pudo instalar ImportExcel. Ejecuta manualmente: Install-Module ImportExcel -Scope CurrentUser" "ERROR"
            return $false
        }
    }
    Import-Module ImportExcel -ErrorAction Stop

    # --- 2. Obtener PAT de GitHub ---
    $pat = Get-GitHubPAT
    if (-not $pat) {
        Write-Log "ERROR: No se encontró GitHub PAT. Configúralo de una de estas formas:" "ERROR"
        Write-Log "  1. Variable de entorno: `$env:DASHBOARD_GITHUB_PAT = 'ghp_xxx...'" "ERROR"
        Write-Log "  2. Archivo .github_pat en la carpeta del script" "ERROR"
        Write-Log "  3. Parámetro: -GitHubPAT 'ghp_xxx...'" "ERROR"
        return $false
    }
    $maskedPat = $pat.Substring(0, [Math]::Min(8, $pat.Length)) + "****"
    Write-Log "PAT configurado: $maskedPat"

    # --- 3. Encontrar archivo Excel ---
    $excelFile = $ExcelPath
    if (-not $excelFile) {
        $excelFile = Find-ExcelFile
    }

    if (-not $excelFile -or -not (Test-Path $excelFile)) {
        Write-Log "ERROR: No se encontró el archivo Excel. Opciones:" "ERROR"
        Write-Log "  1. Verifica que OneDrive esté sincronizado" "ERROR"
        Write-Log "  2. Pasa la ruta explícitamente: -ExcelPath 'C:\ruta\al\archivo.xlsx'" "ERROR"
        return $false
    }

    Write-Log "Archivo Excel: $excelFile"
    Write-Log "Última modificación: $((Get-Item $excelFile).LastWriteTime)"

    # --- 4. Verificar si hay cambios ---
    $currentHash = Get-FileHash256 -Path $excelFile
    if (-not $Force -and (Test-Path $hashFile)) {
        $lastHash = (Get-Content $hashFile -Raw).Trim()
        if ($currentHash -eq $lastHash) {
            Write-Log "Sin cambios detectados en el Excel. Usa -Force para forzar sincronización." "INFO"
            Write-Log "======== FIN (sin cambios) ========"
            return $true
        }
    }
    Write-Log "Cambios detectados (hash: $($currentHash.Substring(0,12))...)"

    # --- 5. Extraer pestaña del Excel a CSV ---
    Write-Log "Extrayendo pestaña '$SheetName'..."
    $tempDir = Join-Path $env:TEMP "dashboard_sync_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
    New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

    try {
        # Leer datos de la pestaña específica
        $data = Import-Excel -Path $excelFile -WorksheetName $SheetName -ErrorAction Stop

        if (-not $data -or $data.Count -eq 0) {
            Write-Log "ERROR: La pestaña '$SheetName' está vacía o no existe." "ERROR"
            return $false
        }

        Write-Log "Registros leídos: $($data.Count)"

        # Generar nombre del CSV
        $excelBaseName = [System.IO.Path]::GetFileNameWithoutExtension($excelFile)
        $csvFileName = "$($excelBaseName)($SheetName).csv"
        $csvPath = Join-Path $tempDir $csvFileName

        # Exportar a CSV con codificación compatible
        $data | Export-Csv -Path $csvPath -NoTypeInformation -Encoding Default
        $csvSizeKB = [Math]::Round((Get-Item $csvPath).Length / 1KB, 1)
        Write-Log "CSV generado: $csvFileName - ${csvSizeKB} KB"

        # --- 6. Crear ZIP ---
        $zipPath = Join-Path $tempDir "datos.zip"
        if (Test-Path $zipPath) { Remove-Item $zipPath -Force }

        Add-Type -AssemblyName System.IO.Compression.FileSystem
        $zipArchive = [System.IO.Compression.ZipFile]::Open($zipPath, 'Create')
        $compressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
            $zipArchive, $csvPath, $csvFileName, $compressionLevel
        ) | Out-Null
        $zipArchive.Dispose()

        $zipSize = (Get-Item $zipPath).Length
        $zipSizeKB = [Math]::Round($zipSize / 1KB, 1)
        Write-Log "ZIP creado: datos.zip - ${zipSizeKB} KB"

        # --- 7. Subir a GitHub ---
        Write-Log "Subiendo a GitHub ${GitHubUser}/${GitHubRepo}..."

        $apiUrl = "https://api.github.com/repos/$GitHubUser/$GitHubRepo/contents/$GitHubFile"
        $authHeaders = @{
            "Authorization" = "token $pat"
            "Accept"        = "application/vnd.github.v3+json"
            "User-Agent"    = "DashboardSync/1.0"
        }

        # Verificar SHA existente
        $existingSha = $null
        try {
            $checkResp = Invoke-RestMethod -Uri "$apiUrl`?ref=$GitHubBranch" -Headers $authHeaders -Method Get -ErrorAction Stop
            $existingSha = $checkResp.sha
            Write-Log "Archivo existente encontrado (SHA: $($existingSha.Substring(0,7)))"
        }
        catch {
            Write-Log "Archivo no existe aún en GitHub, se creará nuevo." "INFO"
        }

        # Leer ZIP como base64
        $zipBytes = [System.IO.File]::ReadAllBytes($zipPath)
        $zipBase64 = [Convert]::ToBase64String($zipBytes)

        # Construir body
        $timestamp = Get-Date -Format "d/M/yyyy, h:mm:ss tt"
        $recordCount = $data.Count
        $body = @{
            message = "Sync auto - $timestamp - $recordCount registros"
            content = $zipBase64
            branch  = $GitHubBranch
        }
        if ($existingSha) { $body.sha = $existingSha }

        $bodyJson = $body | ConvertTo-Json -Depth 10

        # PUT a GitHub API
        $response = Invoke-RestMethod -Uri $apiUrl -Headers $authHeaders -Method Put -Body $bodyJson -ContentType "application/json" -ErrorAction Stop

        # Guardar hash para no re-subir
        Set-Content -Path $hashFile -Value $currentHash -Encoding UTF8

        $newSha = $response.content.sha
        Write-Log "PUBLICADO EXITOSAMENTE a GitHub." "SUCCESS"
        Write-Log "  Registros: $($data.Count)"
        Write-Log "  SHA: $($newSha.Substring(0,12))..."
        Write-Log "  URL: https://$GitHubUser.github.io/$GitHubRepo/"
        Write-Log "======== FIN (éxito) ========"
        return $true
    }
    catch {
        Write-Log "ERROR: $($_.Exception.Message)" "ERROR"
        Write-Log "======== FIN (error) ========"
        return $false
    }
    finally {
        # Limpiar archivos temporales
        if (Test-Path $tempDir) {
            Remove-Item $tempDir -Recurse -Force -ErrorAction SilentlyContinue
        }
    }
}

###############################################################################
# PUNTO DE ENTRADA
###############################################################################

# Manejar instalación/desinstalación de tarea programada
if ($InstallScheduledTask) {
    Install-SyncTask
    exit 0
}
if ($UninstallScheduledTask) {
    Uninstall-SyncTask
    exit 0
}

# Ejecución principal
$result = Invoke-Sync
if (-not $result) {
    exit 1
}
