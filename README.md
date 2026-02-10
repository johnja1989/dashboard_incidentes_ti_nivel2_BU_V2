# 📊 Dashboard Backlog Incidentes TI — Gestión de Incidentes Nivel 2

<p align="center">
  <img src="LOGO.png" alt="Banco Unión S.A." width="200" />
</p>

<p align="center">
  <strong>Vicepresidencia de Tecnología — Banco Unión S.A.</strong><br/>
  Dashboard estadístico en tiempo real para la gestión y seguimiento del Backlog de Incidentes TI Nivel 2
</p>

<p align="center">
  <a href="https://johnja1989.github.io/dashboard_incidentes_ti_nivel2_BU_V2/">🌐 Ver Dashboard en Producción</a>
</p>

---

## 📋 Tabla de Contenido

- [Descripción General](#-descripción-general)
- [Características](#-características)
- [Arquitectura](#-arquitectura)
- [Tecnologías](#-tecnologías)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Instalación y Despliegue](#-instalación-y-despliegue)
- [Uso del Dashboard](#-uso-del-dashboard)
- [Sistema de Sincronización](#-sistema-de-sincronización)
- [Reportes](#-reportes)
- [Seguridad](#-seguridad)
- [Solución de Problemas](#-solución-de-problemas)
- [Changelog](#-changelog)
- [Autor](#-autor)

---

## 🎯 Descripción General

Sistema web de visualización y análisis de datos para el **Backlog de Incidentes TI Nivel 2** del Banco Unión S.A. Transforma los datos operacionales del Excel corporativo (`EST_VPT_BackLog_Incidentes_BU_V001_20250812.xlsx`) alojado en el SharePoint de la Vicepresidencia de Tecnología en un dashboard interactivo con gráficos, KPIs, tablas y reportes ejecutivos.

### Flujo Operativo

```
Excel en SharePoint ← Equipo llena datos de incidentes
        ↓
OneDrive sincroniza a PC local (automático)
        ↓
sync_dashboard.ps1 (automático cada 30 min vía Programador de Tareas)
        ↓
Lee Excel → Extrae pestaña "Backlog Incidentes TI" → CSV → ZIP → GitHub API
        ↓
GitHub Pages sirve el dashboard actualizado (HTTPS)
        ↓
Usuarios acceden al dashboard (auto-refresh cada 3 min)
```

---

## ✨ Características

### Visualización
- 📊 **6 gráficos interactivos** (Chart.js + DataLabels)
- 📈 **KPIs en tiempo real**: Total incidentes, Abiertos, Cerrados, Tasa de resolución
- 📋 **Tabla de datos completa** con scroll horizontal y formato condicional
- 🌙 **Tema oscuro corporativo** optimizado para presentaciones y pantallas

### Reportes Ejecutivos
- 📄 **PDF Ejecutivo**: 5 páginas temáticas con gráficos, tablas y análisis automático
- 📗 **Excel Premium**: 7 hojas especializadas con evaluaciones y recomendaciones
- 🤖 **Narrativa inteligente**: Análisis automático por reglas/umbrales o LLM local opcional

### Sincronización de Datos
- 🔄 **Auto-sync con SharePoint** via PowerShell + Programador de Tareas de Windows
- ☁️ **GitHub Actions** como alternativa de sync en la nube
- 🚀 **Publicación a GitHub** con un click desde el dashboard
- ⏱️ **Auto-refresh cada 3 minutos** para todos los usuarios conectados
- 🔍 **Detección inteligente de cambios** por SHA/hash (evita recargas innecesarias)

### Técnico
- 💾 **Persistencia localStorage**: Los datos sobreviven al refresh del navegador
- 📱 **100% Responsive**: Desktop, tablet y móvil
- 🔒 **HTTPS** nativo en GitHub Pages
- 🌐 **Cero backend**: Todo funciona en el navegador del usuario
- 📦 **Single-file architecture**: Todo empaquetado en `index.html`

---

## 🏗️ Arquitectura

```
┌─────────────────────────────────────────────────────────────┐
│                    FUENTE DE DATOS                           │
│  SharePoint → OneDrive → sync_dashboard.ps1 → GitHub       │
└─────────────┬───────────────────────────────────────────────┘
              │ datos.zip (CSV comprimido)
              ▼
┌─────────────────────────────────────────────────────────────┐
│                   GITHUB PAGES (CDN)                         │
│  index.html + datos.zip + LOGO.png                          │
└─────────────┬───────────────────────────────────────────────┘
              │ HTTPS
              ▼
┌─────────────────────────────────────────────────────────────┐
│                   NAVEGADOR (Cliente)                         │
│                                                               │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ PapaParse│  │ Chart.js │  │  jsPDF   │  │ SheetJS  │   │
│  │ CSV Parse│  │ Gráficos │  │   PDF    │  │  Excel   │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
│                                                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │              localStorage (caché de datos)            │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Tecnologías

| Componente | Tecnología | Versión | Propósito |
|---|---|---|---|
| Frontend | HTML5 + CSS3 + JS ES6 | Nativo | Interfaz y lógica completa |
| Gráficos | Chart.js | 4.4.1 | Visualizaciones interactivas |
| Etiquetas | chartjs-plugin-datalabels | 2.2.0 | Labels en gráficos |
| CSV | PapaParse | 5.4.1 | Parsing de archivos CSV |
| Excel R/W | SheetJS (xlsx) | 0.18.5 | Lectura y escritura Excel |
| PDF | jsPDF + AutoTable | 2.5.1 / 3.8.2 | Generación de reportes PDF |
| Compresión | JSZip | 3.10.1 | Compresión de datos para GitHub |
| Hosting | GitHub Pages | — | Servidor web estático (CDN) |
| Sync | PowerShell + ImportExcel | 5.1+ | Automatización de sincronización |
| CI/CD | GitHub Actions | — | Sync alternativa desde la nube |

Todas las dependencias se cargan desde CDN (jsDelivr/cdnjs) — no requiere `npm install`.

---

## 📂 Estructura del Proyecto

```
dashboard_incidentes_ti_nivel2_BU_V2/
│
├── index.html                          # Dashboard principal (single-file app)
├── LOGO.png                            # Logo corporativo Banco Unión S.A.
├── datos.zip                           # Datos CSV comprimidos (auto-generado)
├── robots.txt                          # Control de indexación para buscadores
│
├── sync_dashboard.ps1                  # Script PowerShell de sincronización automática
│
├── .github/
│   └── workflows/
│       └── sync-sharepoint.yml         # GitHub Actions: sync desde SharePoint
│
├── .gitignore                          # Exclusiones Git (tokens, logs, temporales)
├── README.md                           # Documentación principal del proyecto
├── CHANGELOG.md                        # Historial de versiones
├── SECURITY.md                         # Política de seguridad y manejo de datos
├── LICENSE                             # Licencia de uso interno corporativo
│
└── docs/
    ├── GUIA_DESPLIEGUE.md              # Guía de despliegue en GitHub Pages
    ├── GUIA_SINCRONIZACION.md          # Guía de sincronización automática
    ├── REPORTES_EJECUTIVOS.md          # Documentación de reportes PDF/Excel
    ├── CHECKLIST_ENTREGA.md            # Checklist de entrega y presentación
    └── DICCIONARIO_DATOS.md            # Diccionario de datos del CSV/Excel
```

---

## 🚀 Instalación y Despliegue

### Pre-requisitos

- Navegador moderno (Chrome 90+, Firefox 90+, Edge 90+, Safari 15+)
- Cuenta de GitHub con GitHub Pages habilitado
- (Para sync automático) Windows 10/11 con OneDrive for Business sincronizado

### Despliegue en GitHub Pages

1. Crear repositorio en GitHub (público o privado con GitHub Pro)
2. Subir todos los archivos del proyecto
3. Ir a **Settings** → **Pages** → Source: `main` / `/ (root)` → **Save**
4. Esperar 1-2 minutos; el dashboard estará disponible en:
   ```
   https://<usuario>.github.io/<nombre-repo>/
   ```

> 📘 Para instrucciones detalladas paso a paso, ver [docs/GUIA_DESPLIEGUE.md](docs/GUIA_DESPLIEGUE.md)

### Ejecución Local (desarrollo)

```bash
# Opción 1: Python
python -m http.server 8000

# Opción 2: Node.js
npx http-server -p 8000

# Opción 3: VS Code
# Extensión "Live Server" → Click derecho en index.html → Open with Live Server
```

Abrir `http://localhost:8000` en el navegador.

---

## 📖 Uso del Dashboard

### Carga Manual de Datos

1. Exportar la pestaña **"Backlog Incidentes TI"** del Excel a CSV (Windows-1252)
2. Click en **📂 Cargar CSV** en el dashboard
3. Seleccionar el archivo CSV exportado
4. Los gráficos y tabla se actualizan automáticamente
5. Click en **🚀 Publicar a GitHub** para que todos los usuarios vean la actualización

### Sincronización Automática (recomendado)

```powershell
# Configuración inicial (una sola vez)
Install-Module ImportExcel -Scope CurrentUser
[Environment]::SetEnvironmentVariable("DASHBOARD_GITHUB_PAT", "ghp_TU_TOKEN", "User")

# Probar sincronización manual
.\sync_dashboard.ps1

# Instalar tarea automática cada 30 minutos
.\sync_dashboard.ps1 -InstallScheduledTask -IntervalMinutes 30
```

> 📘 Guía completa en [docs/GUIA_SINCRONIZACION.md](docs/GUIA_SINCRONIZACION.md)

### Formato del CSV Esperado

El dashboard detecta columnas automáticamente. Principales:

| Columna | Aliases aceptados | Ejemplo |
|---|---|---|
| ID | `ID_INC`, `ID` | 1, 2, 3 |
| N° Incidente | `Nro Incidente`, `Número` | 138648, GYF-518 |
| Caso Genial | `Caso Genial`, `Caso` | 2403040050 |
| Estado | `Estado Final Incidente`, `Status` | Abierto, Cerrado |
| Responsable | `Ingeniero Asignado`, `Asignado` | Juan Pérez |
| Tiempo | `Edad Incidente`, `Días` | 15 |
| Servicio | `Servicio`, `Categoría` | Base de Datos |
| Proveedor | `Proveedor a escalar`, `Vendor` | Oracle |
| Seguimiento | `Seguimiento BU` | Texto de seguimiento |

> 📘 Diccionario completo en [docs/DICCIONARIO_DATOS.md](docs/DICCIONARIO_DATOS.md)

---

## 🔄 Sistema de Sincronización

| Método | Automatización | Requiere PC | CORS | Confiabilidad |
|---|---|---|---|---|
| **PowerShell** (recomendado) | ✅ Total | Sí | Sin problemas | ⭐⭐⭐⭐⭐ |
| **GitHub Actions** | ✅ Total | No | Sin problemas | ⭐⭐⭐⭐ |
| **Botón Sync SharePoint** | Semi-manual | Sí | Posibles | ⭐⭐⭐ |
| **Carga manual CSV** | Manual | Sí | N/A | ⭐⭐⭐⭐⭐ |

> 📘 Detalles y configuración en [docs/GUIA_SINCRONIZACION.md](docs/GUIA_SINCRONIZACION.md)

---

## 📊 Reportes

### PDF Ejecutivo (5 páginas)
1. **Portada corporativa** con KPIs principales
2. **Resumen ejecutivo** con métricas y cumplimiento de metas
3. **Análisis de recursos** — Top 10 responsables y carga de trabajo
4. **Servicios más afectados** — Ranking con prioridades
5. **Análisis de proveedores** — Escalamientos y evaluación SLA

### Excel Premium (7 hojas)
1. Dashboard Ejecutivo con KPIs y recomendaciones automáticas
2. Gráfico de Estados (datos para gráfico circular)
3. Top Responsables con evaluación de carga
4. Top Servicios con prioridades de atención
5. Análisis Temporal por rangos de edad
6. Proveedores y estadísticas de escalamiento
7. Datos completos del Backlog

> 📘 Documentación detallada en [docs/REPORTES_EJECUTIVOS.md](docs/REPORTES_EJECUTIVOS.md)

---

## 🔐 Seguridad

| Aspecto | Implementación |
|---|---|
| Procesamiento de datos | Local en el navegador (no se envía a terceros) |
| Almacenamiento tokens | localStorage del navegador (solo admin) |
| Archivo `.github_pat` | Excluido por `.gitignore` |
| Transporte | HTTPS vía GitHub Pages |
| Datos en tránsito | CSV comprimido en ZIP |
| Acceso al repositorio | Configurable (público o privado con GitHub Pro) |

> 📘 Política completa en [SECURITY.md](SECURITY.md)

---

## 🐛 Solución de Problemas

| Problema | Solución |
|---|---|
| Dashboard no carga | Verificar GitHub Pages activo en Settings → Pages |
| Acentos/ñ se ven mal (carácter `�`) | Exportar CSV como Windows-1252 o UTF-8 con BOM |
| Gráficos no se actualizan | Click en 🧹 **Limpiar caché** → Recargar con Ctrl+F5 |
| Error al publicar en GitHub | Verificar PAT en ⚙️ **Config GitHub** (necesita permiso `repo`) |
| Script PowerShell no encuentra Excel | Verificar sincronización OneDrive del SharePoint |
| Error CORS al sincronizar | Usar script PowerShell o configurar proxy CORS |
| GitHub Pages muestra 404 | Verificar que `index.html` existe en la raíz del repositorio |

---

## 📝 Changelog

Ver [CHANGELOG.md](CHANGELOG.md) para el historial completo de versiones.

---

## 👨‍💻 Autor

**John Jairo Vargas González**  
Ingeniero de Soluciones TI  
Vicepresidencia de Tecnología — Banco Unión S.A.  
📧 john.vargas@bancounion.com

---

## 📄 Licencia

Proyecto de uso interno corporativo. Propiedad de **Banco Unión S.A.**  
Ver [LICENSE](LICENSE) para detalles.

---

<p align="center">
  <em>"Transformando datos en decisiones estratégicas"</em><br/>
  <strong>Banco Unión S.A.</strong> — Vicepresidencia de Tecnología © 2025-2026
</p>

