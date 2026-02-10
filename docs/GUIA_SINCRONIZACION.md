# Guía de Sincronización Automática: SharePoint → Dashboard

## El Problema
Actualmente debes:
1. Descargar manualmente el Excel de SharePoint
2. Exportar la pestaña "Backlog Incidentes TI" a CSV
3. Cargar el CSV en el dashboard
4. Publicar a GitHub

## Soluciones Disponibles (sin necesidad de apps Azure/OneDrive)

---

## ⭐ Solución 1: Script PowerShell + Programador de Tareas (RECOMENDADA)

**La más robusta y confiable.** Lee el Excel directamente desde la carpeta local sincronizada por OneDrive y sube automáticamente a GitHub.

### Pre-requisitos
- OneDrive for Business sincronizando la carpeta de SharePoint
- PowerShell 5.1+ (incluido en Windows 10/11)
- GitHub Personal Access Token (PAT)

### Configuración Paso a Paso

#### 1. Verificar que OneDrive sincroniza el archivo

El archivo `EST_VPT_BackLog_Incidentes_BU_V001_20250812.xlsx` debe estar visible como archivo local en tu PC a través de OneDrive. Generalmente se encuentra en:
```
C:\Users\TU_USUARIO\OneDrive - Banco Unión\...\EST_VPT_BackLog_Incidentes_BU_V001_20250812.xlsx
```

Si no está sincronizado:
1. Abre SharePoint en el navegador
2. Ve a la biblioteca de documentos donde está el archivo
3. Click en **"Sincronizar"** (en la barra de herramientas)
4. OneDrive sincronizará esa carpeta automáticamente

#### 2. Instalar el módulo ImportExcel

Abre PowerShell como usuario normal y ejecuta:
```powershell
Install-Module ImportExcel -Scope CurrentUser -Force
```

#### 3. Configurar el GitHub PAT

Opción A — Variable de entorno (recomendada):
```powershell
# Permanente para tu usuario
[Environment]::SetEnvironmentVariable("DASHBOARD_GITHUB_PAT", "ghp_TU_TOKEN_AQUI", "User")
```

Opción B — Archivo `.github_pat`:
```powershell
# Crear archivo en la carpeta del script
"ghp_TU_TOKEN_AQUI" | Out-File -FilePath ".github_pat" -Encoding UTF8 -NoNewline
```

#### 4. Probar manualmente

```powershell
# Si OneDrive sincroniza el archivo, el script lo encuentra automáticamente:
.\sync_dashboard.ps1

# O especificar la ruta explícitamente:
.\sync_dashboard.ps1 -ExcelPath "C:\Users\john.vargas\OneDrive - Banco Union\...\EST_VPT_BackLog_Incidentes_BU_V001_20250812.xlsx"

# Forzar subida aunque no haya cambios:
.\sync_dashboard.ps1 -Force
```

#### 5. Programar ejecución automática

Opción A — Usando el script:
```powershell
# Instalar tarea programada que se ejecuta cada 30 minutos
.\sync_dashboard.ps1 -InstallScheduledTask -IntervalMinutes 30

# Para desinstalar:
.\sync_dashboard.ps1 -UninstallScheduledTask
```

Opción B — Manual en Programador de Tareas:
1. Abre `taskschd.msc`
2. Crear tarea básica → Nombre: `DashboardSync`
3. Desencadenador: Repetir cada `30 minutos` por `1 día`
4. Acción: Iniciar programa
   - Programa: `powershell.exe`
   - Argumentos: `-NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "C:\RUTA\sync_dashboard.ps1"`

### Verificar que funciona
- Revisa el archivo `sync_dashboard.log` para ver el historial
- El dashboard se actualiza automáticamente cada 3 minutos (ya lo hace)

---

## Solución 2: GitHub Actions (automática en la nube)

**Ventaja:** No necesita tu PC encendida. Se ejecuta en GitHub.
**Desventaja:** Requiere un enlace de descarga de SharePoint que no expire fácilmente.

### Configuración

#### 1. Obtener enlace de descarga de SharePoint

1. Abre el Excel en SharePoint
2. Click en **Compartir** → **Copiar vínculo**
3. Elige **"Personas de [tu organización] con el vínculo"** → **Puede ver**
4. Copia el enlace. Se verá algo como:
   ```
   https://gyf.sharepoint.com/:x:/s/SHAREPOINTVICEPRESIDENCIADETECNOLOGA/ExxxxxxQ?e=xxxxx
   ```
5. Modifica el enlace para descarga directa agregando `&download=1`:
   ```
   https://gyf.sharepoint.com/:x:/s/SHAREPOINTVICEPRESIDENCIADETECNOLOGA/ExxxxxxQ?e=xxxxx&download=1
   ```

#### 2. Configurar el secreto en GitHub

1. Ve a tu repositorio en GitHub
2. **Settings** → **Secrets and variables** → **Actions**
3. **New repository secret**:
   - Name: `SHAREPOINT_DOWNLOAD_URL`
   - Value: el enlace de descarga del paso anterior

#### 3. Subir el workflow

El archivo `.github/workflows/sync-sharepoint.yml` ya está creado. Solo haz push:
```bash
git add .github/workflows/sync-sharepoint.yml
git commit -m "Add SharePoint auto-sync workflow"
git push
```

#### 4. Probar

1. Ve a tu repositorio → **Actions**
2. Selecciona **"Sync Dashboard desde SharePoint"**
3. Click en **"Run workflow"** → **Run workflow**

El workflow se ejecutará automáticamente cada 30 minutos en horario laboral (Lun-Vie, 8am-7pm hora Bolivia).

### ⚠️ Limitaciones
- Si el enlace de SharePoint expira, deberás renovarlo en Secrets
- Algunos SharePoint corporativos bloquean descargas externas

---

## Solución 3: Botón "Sync SharePoint" en el Dashboard

**Ventaja:** Un click en lugar de 4 pasos manuales.
**Desventaja:** Requiere que tú (admin) hagas click. Puede tener problemas de CORS.

### Cómo funciona

Se agregó un botón **"🔄 Sync SharePoint"** al dashboard que:
1. Descarga el Excel directamente desde SharePoint
2. Lee la pestaña "Backlog Incidentes TI" con SheetJS
3. Actualiza el dashboard
4. Opcionalmente publica a GitHub

### Configuración

1. Abre el dashboard
2. Click en **🔄 Sync SharePoint**
3. Configura:
   - **URL de descarga**: El enlace de SharePoint con `?download=1`
   - **Proxy CORS** (si falla): Usa `https://corsproxy.io/?` o similar
   - **Auto-sync**: Intervalo en minutos (0 = desactivado)
4. Click en **"Probar conexión"** para verificar
5. Click en **"Guardar y Sincronizar"**

### Si tienes error de CORS

SharePoint bloquea peticiones desde otros dominios (CORS). Soluciones:
1. Usa un proxy CORS: `https://corsproxy.io/?`
2. O usa la Solución 1 (PowerShell) que no tiene este problema

---

## Comparativa de Soluciones

| Característica | PowerShell (S1) | GitHub Actions (S2) | Botón Dashboard (S3) |
|---|---|---|---|
| **Automatización** | ✅ Total | ✅ Total | ⚠️ Semi-manual |
| **Requiere PC encendida** | ⚠️ Sí | ✅ No | ⚠️ Sí |
| **Problemas de CORS** | ✅ Ninguno | ✅ Ninguno | ⚠️ Posibles |
| **Requiere app Azure** | ✅ No | ✅ No | ✅ No |
| **Dificultad** | Media | Media | Fácil |
| **Confiabilidad** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |

### Recomendación

**Usa la Solución 1 (PowerShell)** como principal — es la más confiable y no tiene problemas de CORS ni de enlaces que expiran. Tu PC ya está sincronizada con OneDrive, así que el script lee el archivo local directamente.

Complementa con la **Solución 3 (botón)** para sincronizaciones puntuales rápidas si tu PC está disponible. 

---

## Archivos Creados

| Archivo | Descripción |
|---|---|
| `sync_dashboard.ps1` | Script PowerShell de sincronización automática |
| `.github/workflows/sync-sharepoint.yml` | GitHub Actions workflow |
| `Guía Sincronización Automática SharePoint.md` | Esta guía |

## Flujo Final Automatizado

```
Excel en SharePoint ← Usuarios llenan datos
        ↓
OneDrive sincroniza a tu PC (automático)
        ↓
sync_dashboard.ps1 (cada 30 min via Task Scheduler)
        ↓
Lee Excel → Extrae pestaña → CSV → ZIP → GitHub API
        ↓
GitHub Pages sirve el dashboard actualizado
        ↓
Usuarios ven datos actualizados (auto-refresh cada 3 min)
```
