# ðŸ“Š Dashboard Backlog Incidentes TI â€” GestiÃ³n de Incidentes Nivel 2

<p align="center">
  <img src="LOGO.png" alt="Banco UniÃ³n S.A." width="200" />
</p>

<p align="center">
  <strong>Vicepresidencia de TecnologÃ­a â€” Banco UniÃ³n S.A.</strong><br/>
  Dashboard estadÃ­stico en tiempo real para la gestiÃ³n y seguimiento del Backlog de Incidentes TI Nivel 2
</p>

<p align="center">
  <a href="https://johnja1989.github.io/dashboard_incidentes_ti_nivel2_BU_V2/">ðŸŒ Ver Dashboard en ProducciÃ³n</a>
</p>

---

## ðŸ“‹ Tabla de Contenido

- [DescripciÃ³n General](#-descripciÃ³n-general)
- [CaracterÃ­sticas](#-caracterÃ­sticas)
- [Arquitectura](#-arquitectura)
- [TecnologÃ­as](#-tecnologÃ­as)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [InstalaciÃ³n y Despliegue](#-instalaciÃ³n-y-despliegue)
- [Uso del Dashboard](#-uso-del-dashboard)
- [Sistema de SincronizaciÃ³n](#-sistema-de-sincronizaciÃ³n)
- [Reportes](#-reportes)
- [Seguridad](#-seguridad)
- [SoluciÃ³n de Problemas](#-soluciÃ³n-de-problemas)
- [Changelog](#-changelog)
- [Autor](#-autor)

---

## ðŸŽ¯ DescripciÃ³n General

Sistema web de visualizaciÃ³n y anÃ¡lisis de datos para el **Backlog de Incidentes TI Nivel 2** del Banco UniÃ³n S.A. Transforma los datos operacionales del Excel corporativo (`EST_VPT_BackLog_Incidentes_BU_V001_20250812.xlsx`) alojado en el SharePoint de la Vicepresidencia de TecnologÃ­a en un dashboard interactivo con grÃ¡ficos, KPIs, tablas y reportes ejecutivos.

### Flujo Operativo

```
Excel en SharePoint â† Equipo llena datos de incidentes
        â†“
OneDrive sincroniza a PC local (automÃ¡tico)
        â†“
sync_dashboard.ps1 (automÃ¡tico cada 30 min vÃ­a Programador de Tareas)
        â†“
Lee Excel â†’ Extrae pestaÃ±a "Backlog Incidentes TI" â†’ CSV â†’ ZIP â†’ GitHub API
        â†“
GitHub Pages sirve el dashboard actualizado (HTTPS)
        â†“
Usuarios acceden al dashboard (auto-refresh cada 3 min)
```

---

## âœ¨ CaracterÃ­sticas

### VisualizaciÃ³n
- ðŸ“Š **6 grÃ¡ficos interactivos** (Chart.js + DataLabels)
- ðŸ“ˆ **KPIs en tiempo real**: Total incidentes, Abiertos, Cerrados, Tasa de resoluciÃ³n
- ðŸ“‹ **Tabla de datos completa** con scroll horizontal y formato condicional
- ðŸŒ™ **Tema oscuro corporativo** optimizado para presentaciones y pantallas

### Reportes Ejecutivos
- ðŸ“„ **PDF Ejecutivo**: 5 pÃ¡ginas temÃ¡ticas con grÃ¡ficos, tablas y anÃ¡lisis automÃ¡tico
- ðŸ“— **Excel Premium**: 7 hojas especializadas con evaluaciones y recomendaciones
- ðŸ¤– **Narrativa inteligente**: AnÃ¡lisis automÃ¡tico por reglas/umbrales o LLM local opcional

### SincronizaciÃ³n de Datos
- ðŸ”„ **Auto-sync con SharePoint** via PowerShell + Programador de Tareas de Windows
- â˜ï¸ **GitHub Actions** como alternativa de sync en la nube
- ðŸš€ **PublicaciÃ³n a GitHub** con un click desde el dashboard
- â±ï¸ **Auto-refresh cada 3 minutos** para todos los usuarios conectados
- ðŸ” **DetecciÃ³n inteligente de cambios** por SHA/hash (evita recargas innecesarias)

### TÃ©cnico
- ðŸ’¾ **Persistencia localStorage**: Los datos sobreviven al refresh del navegador
- ðŸ“± **100% Responsive**: Desktop, tablet y mÃ³vil
- ðŸ”’ **HTTPS** nativo en GitHub Pages
- ðŸŒ **Cero backend**: Todo funciona en el navegador del usuario
- ðŸ“¦ **Single-file architecture**: Todo empaquetado en `index.html`

---

## ðŸ—ï¸ Arquitectura

```
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚                    FUENTE DE DATOS                           â”‚
â”‚  SharePoint â†’ OneDrive â†’ sync_dashboard.ps1 â†’ GitHub       â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
              â”‚ datos.zip (CSV comprimido)
              â–¼
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚                   GITHUB PAGES (CDN)                         â”‚
â”‚  index.html + datos.zip + LOGO.png                          â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”¬â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
              â”‚ HTTPS
              â–¼
â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”
â”‚                   NAVEGADOR (Cliente)                         â”‚
â”‚                                                               â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   â”‚
â”‚  â”‚ PapaParseâ”‚  â”‚ Chart.js â”‚  â”‚  jsPDF   â”‚  â”‚ SheetJS  â”‚   â”‚
â”‚  â”‚ CSV Parseâ”‚  â”‚ GrÃ¡ficos â”‚  â”‚   PDF    â”‚  â”‚  Excel   â”‚   â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   â”‚
â”‚                                                               â”‚
â”‚  â”Œâ”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”   â”‚
â”‚  â”‚              localStorage (cachÃ© de datos)            â”‚   â”‚
â”‚  â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜   â”‚
â””â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”˜
```

---

## ðŸ› ï¸ TecnologÃ­as

| Componente | TecnologÃ­a | VersiÃ³n | PropÃ³sito |
|---|---|---|---|
| Frontend | HTML5 + CSS3 + JS ES6 | Nativo | Interfaz y lÃ³gica completa |
| GrÃ¡ficos | Chart.js | 4.4.1 | Visualizaciones interactivas |
| Etiquetas | chartjs-plugin-datalabels | 2.2.0 | Labels en grÃ¡ficos |
| CSV | PapaParse | 5.4.1 | Parsing de archivos CSV |
| Excel R/W | SheetJS (xlsx) | 0.18.5 | Lectura y escritura Excel |
| PDF | jsPDF + AutoTable | 2.5.1 / 3.8.2 | GeneraciÃ³n de reportes PDF |
| CompresiÃ³n | JSZip | 3.10.1 | CompresiÃ³n de datos para GitHub |
| Hosting | GitHub Pages | â€” | Servidor web estÃ¡tico (CDN) |
| Sync | PowerShell + ImportExcel | 5.1+ | AutomatizaciÃ³n de sincronizaciÃ³n |
| CI/CD | GitHub Actions | â€” | Sync alternativa desde la nube |

Todas las dependencias se cargan desde CDN (jsDelivr/cdnjs) â€” no requiere `npm install`.

---

## ðŸ“‚ Estructura del Proyecto

```
dashboard_incidentes_ti_nivel2_BU_V2/
â”‚
â”œâ”€â”€ index.html                          # Dashboard principal (single-file app)
â”œâ”€â”€ LOGO.png                            # Logo corporativo Banco UniÃ³n S.A.
â”œâ”€â”€ datos.zip                           # Datos CSV comprimidos (auto-generado)
â”œâ”€â”€ robots.txt                          # Control de indexaciÃ³n para buscadores
â”‚
â”œâ”€â”€ sync_dashboard.ps1                  # Script PowerShell de sincronizaciÃ³n automÃ¡tica
â”‚
â”œâ”€â”€ .github/
â”‚   â””â”€â”€ workflows/
â”‚       â””â”€â”€ sync-sharepoint.yml         # GitHub Actions: sync desde SharePoint
â”‚
â”œâ”€â”€ .gitignore                          # Exclusiones Git (tokens, logs, temporales)
â”œâ”€â”€ README.md                           # DocumentaciÃ³n principal del proyecto
â”œâ”€â”€ CHANGELOG.md                        # Historial de versiones
â”œâ”€â”€ SECURITY.md                         # PolÃ­tica de seguridad y manejo de datos
â”œâ”€â”€ LICENSE                             # Licencia de uso interno corporativo
â”‚
â””â”€â”€ docs/
    â”œâ”€â”€ GUIA_DESPLIEGUE.md              # GuÃ­a de despliegue en GitHub Pages
    â”œâ”€â”€ GUIA_SINCRONIZACION.md          # GuÃ­a de sincronizaciÃ³n automÃ¡tica
    â”œâ”€â”€ REPORTES_EJECUTIVOS.md          # DocumentaciÃ³n de reportes PDF/Excel
    â”œâ”€â”€ CHECKLIST_ENTREGA.md            # Checklist de entrega y presentaciÃ³n
    â””â”€â”€ DICCIONARIO_DATOS.md            # Diccionario de datos del CSV/Excel
```

---

## ðŸš€ InstalaciÃ³n y Despliegue

### Pre-requisitos

- Navegador moderno (Chrome 90+, Firefox 90+, Edge 90+, Safari 15+)
- Cuenta de GitHub con GitHub Pages habilitado
- (Para sync automÃ¡tico) Windows 10/11 con OneDrive for Business sincronizado

### Despliegue en GitHub Pages

1. Crear repositorio en GitHub (pÃºblico o privado con GitHub Pro)
2. Subir todos los archivos del proyecto
3. Ir a **Settings** â†’ **Pages** â†’ Source: `main` / `/ (root)` â†’ **Save**
4. Esperar 1-2 minutos; el dashboard estarÃ¡ disponible en:
   ```
   https://<usuario>.github.io/<nombre-repo>/
   ```

> ðŸ“˜ Para instrucciones detalladas paso a paso, ver [docs/GUIA_DESPLIEGUE.md](docs/GUIA_DESPLIEGUE.md)

### EjecuciÃ³n Local (desarrollo)

```bash
# OpciÃ³n 1: Python
python -m http.server 8000

# OpciÃ³n 2: Node.js
npx http-server -p 8000

# OpciÃ³n 3: VS Code
# ExtensiÃ³n "Live Server" â†’ Click derecho en index.html â†’ Open with Live Server
```

Abrir `http://localhost:8000` en el navegador.

---

## ðŸ“– Uso del Dashboard

### Carga Manual de Datos

1. Exportar la pestaÃ±a **"Backlog Incidentes TI"** del Excel a CSV (Windows-1252)
2. Click en **ðŸ“‚ Cargar CSV** en el dashboard
3. Seleccionar el archivo CSV exportado
4. Los grÃ¡ficos y tabla se actualizan automÃ¡ticamente
5. Click en **ðŸš€ Publicar a GitHub** para que todos los usuarios vean la actualizaciÃ³n

### SincronizaciÃ³n AutomÃ¡tica (recomendado)

```powershell
# ConfiguraciÃ³n inicial (una sola vez)
Install-Module ImportExcel -Scope CurrentUser
[Environment]::SetEnvironmentVariable("DASHBOARD_GITHUB_PAT", "ghp_TU_TOKEN", "User")

# Probar sincronizaciÃ³n manual
.\sync_dashboard.ps1

# Instalar tarea automÃ¡tica cada 30 minutos
.\sync_dashboard.ps1 -InstallScheduledTask -IntervalMinutes 30
```

> ðŸ“˜ GuÃ­a completa en [docs/GUIA_SINCRONIZACION.md](docs/GUIA_SINCRONIZACION.md)

### Formato del CSV Esperado

El dashboard detecta columnas automÃ¡ticamente. Principales:

| Columna | Aliases aceptados | Ejemplo |
|---|---|---|
| ID | `ID_INC`, `ID` | 1, 2, 3 |
| NÂ° Incidente | `Nro Incidente`, `NÃºmero` | 138648, GYF-518 |
| Caso Genial | `Caso Genial`, `Caso` | 2403040050 |
| Estado | `Estado Final Incidente`, `Status` | Abierto, Cerrado |
| Responsable | `Ingeniero Asignado`, `Asignado` | Juan PÃ©rez |
| Tiempo | `Edad Incidente`, `DÃ­as` | 15 |
| Servicio | `Servicio`, `CategorÃ­a` | Base de Datos |
| Proveedor | `Proveedor a escalar`, `Vendor` | Oracle |
| Seguimiento | `Seguimiento BU` | Texto de seguimiento |

> ðŸ“˜ Diccionario completo en [docs/DICCIONARIO_DATOS.md](docs/DICCIONARIO_DATOS.md)

---

## ðŸ”„ Sistema de SincronizaciÃ³n

| MÃ©todo | AutomatizaciÃ³n | Requiere PC | CORS | Confiabilidad |
|---|---|---|---|---|
| **PowerShell** (recomendado) | âœ… Total | SÃ­ | Sin problemas | â­â­â­â­â­ |
| **GitHub Actions** | âœ… Total | No | Sin problemas | â­â­â­â­ |
| **BotÃ³n Sync SharePoint** | Semi-manual | SÃ­ | Posibles | â­â­â­ |
| **Carga manual CSV** | Manual | SÃ­ | N/A | â­â­â­â­â­ |

> ðŸ“˜ Detalles y configuraciÃ³n en [docs/GUIA_SINCRONIZACION.md](docs/GUIA_SINCRONIZACION.md)

---

## ðŸ“Š Reportes

### PDF Ejecutivo (5 pÃ¡ginas)
1. **Portada corporativa** con KPIs principales
2. **Resumen ejecutivo** con mÃ©tricas y cumplimiento de metas
3. **AnÃ¡lisis de recursos** â€” Top 10 responsables y carga de trabajo
4. **Servicios mÃ¡s afectados** â€” Ranking con prioridades
5. **AnÃ¡lisis de proveedores** â€” Escalamientos y evaluaciÃ³n SLA

### Excel Premium (7 hojas)
1. Dashboard Ejecutivo con KPIs y recomendaciones automÃ¡ticas
2. GrÃ¡fico de Estados (datos para grÃ¡fico circular)
3. Top Responsables con evaluaciÃ³n de carga
4. Top Servicios con prioridades de atenciÃ³n
5. AnÃ¡lisis Temporal por rangos de edad
6. Proveedores y estadÃ­sticas de escalamiento
7. Datos completos del Backlog

> ðŸ“˜ DocumentaciÃ³n detallada en [docs/REPORTES_EJECUTIVOS.md](docs/REPORTES_EJECUTIVOS.md)

---

## ðŸ” Seguridad

| Aspecto | ImplementaciÃ³n |
|---|---|
| Procesamiento de datos | Local en el navegador (no se envÃ­a a terceros) |
| Almacenamiento tokens | localStorage del navegador (solo admin) |
| Archivo `.github_pat` | Excluido por `.gitignore` |
| Transporte | HTTPS vÃ­a GitHub Pages |
| Datos en trÃ¡nsito | CSV comprimido en ZIP |
| Acceso al repositorio | Configurable (pÃºblico o privado con GitHub Pro) |

> ðŸ“˜ PolÃ­tica completa en [SECURITY.md](SECURITY.md)

---

## ðŸ› SoluciÃ³n de Problemas

| Problema | SoluciÃ³n |
|---|---|
| Dashboard no carga | Verificar GitHub Pages activo en Settings â†’ Pages |
| Acentos/Ã± se ven mal (carÃ¡cter `ï¿½`) | Exportar CSV como Windows-1252 o UTF-8 con BOM |
| GrÃ¡ficos no se actualizan | Click en ðŸ§¹ **Limpiar cachÃ©** â†’ Recargar con Ctrl+F5 |
| Error al publicar en GitHub | Verificar PAT en âš™ï¸ **Config GitHub** (necesita permiso `repo`) |
| Script PowerShell no encuentra Excel | Verificar sincronizaciÃ³n OneDrive del SharePoint |
| Error CORS al sincronizar | Usar script PowerShell o configurar proxy CORS |
| GitHub Pages muestra 404 | Verificar que `index.html` existe en la raÃ­z del repositorio |

---

## ðŸ“ Changelog

Ver [CHANGELOG.md](CHANGELOG.md) para el historial completo de versiones.

---

## ðŸ‘¨â€ðŸ’» Autor

**John Jairo Vargas GonzÃ¡lez**  
Ingeniero de Soluciones TI  
Vicepresidencia de TecnologÃ­a â€” Banco UniÃ³n S.A.  
ðŸ“§ john.vargas@bancounion.com

---

## ðŸ“„ Licencia

Proyecto de uso interno corporativo. Propiedad de **Banco UniÃ³n S.A.**  
Ver [LICENSE](LICENSE) para detalles.

---

<p align="center">
  <em>"Transformando datos en decisiones estratÃ©gicas"</em><br/>
  <strong>Banco UniÃ³n S.A.</strong> â€” Vicepresidencia de TecnologÃ­a Â© 2025-2026
</p>

