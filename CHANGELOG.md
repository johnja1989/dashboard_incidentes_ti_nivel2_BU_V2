# Changelog — Dashboard Backlog Incidentes TI

Todos los cambios notables de este proyecto se documentan en este archivo.

El formato está basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/)
y este proyecto sigue [Versionado Semántico](https://semver.org/lang/es/).

---

## [1.5.0] — 2026-02-10

### Agregado
- **Sincronización automática con SharePoint** via script PowerShell (`sync_dashboard.ps1`)
- **GitHub Actions workflow** para sync automático desde la nube (`sync-sharepoint.yml`)
- **Botón "Sync SharePoint"** en el dashboard para sincronización directa
- Archivo `.gitignore` para proteger tokens y archivos sensibles
- Documentación empresarial completa:
  - `CHANGELOG.md` — Historial de versiones
  - `SECURITY.md` — Política de seguridad
  - `LICENSE` — Licencia de uso interno
  - `robots.txt` — Control de indexación
  - `docs/DICCIONARIO_DATOS.md` — Diccionario de datos
- Soporte para proxy CORS en sincronización SharePoint
- Auto-configuración de tarea programada en Windows Task Scheduler
- Detección automática de archivo Excel en carpetas OneDrive

### Mejorado
- `README.md` reescrito completamente para reflejar la arquitectura actual
- Documentación profesional reorganizada en carpeta `docs/`
- Checklist de entrega actualizado para la estructura actual del proyecto

---

## [1.4.0] — 2026-01-27

### Agregado
- **Sistema de sincronización GitHub**: Publicar datos a GitHub para que todos los usuarios vean la actualización
- **Auto-refresh cada 3 minutos**: El dashboard verifica automáticamente si hay datos nuevos en GitHub
- Diálogo de configuración de GitHub PAT con validación
- Detección de cambios por SHA para evitar recargas innecesarias
- Compresión ZIP de datos CSV para optimizar transferencia
- Botón "Publicar a GitHub" con feedback visual
- Botón "Config GitHub" para gestión de tokens

### Mejorado
- Carga de datos desde GitHub al iniciar el dashboard
- Indicadores de estado de sincronización en la barra de herramientas

---

## [1.3.0] — 2025-12-14

### Agregado
- **Reporte PDF Ejecutivo Premium**: 5 páginas temáticas con gráficos incrustados
  - Portada corporativa con KPIs
  - Resumen ejecutivo con métricas y cumplimiento de metas
  - Análisis de recursos (Top 10 responsables)
  - Servicios más afectados con prioridades
  - Análisis de proveedores y escalamientos
- **Reporte Excel Premium**: 7 hojas especializadas
  - Dashboard Ejecutivo, Estados, Responsables, Servicios, Temporal, Proveedores, Datos Completos
- Recomendaciones automáticas basadas en umbrales
- Narrativa ejecutiva generada por reglas (Camino A) con fallback a LLM local (Camino B)
- Logo corporativo en reportes PDF

### Mejorado
- Orientación horizontal (landscape) en todos los PDFs
- Tablas con formato profesional y colores corporativos

---

## [1.2.0] — 2025-11-20

### Agregado
- **Banner de estado**: Muestra archivo cargado y timestamp de guardado
- **Persistencia localStorage**: Los datos sobreviven al refrescar la página
- Botón "Limpiar caché" para resetear el estado
- Soporte para codificación Windows-1252 (acentos y ñ)
- Detección automática de columnas (schema inference)

### Mejorado
- Manejo de errores en carga de CSV
- Feedback visual al usuario durante procesamiento

---

## [1.1.0] — 2025-10-15

### Agregado
- **6 gráficos interactivos** con Chart.js:
  - KPI: Total de incidentes reportados (doughnut)
  - Estado de incidentes: Abiertos vs Cerrados (pie)
  - Distribución por rango de edad (barras)
  - Casos por responsable/ingeniero (barras horizontales)
  - Tipificación por servicio (barras)
  - Casos por proveedor (barras)
- Tabla de datos con todas las columnas
- Plugin ChartDataLabels para etiquetas en gráficos
- Diseño responsive para móvil y tablet

### Mejorado
- Tema oscuro corporativo con gradientes
- Separación visual entre secciones de gráficos

---

## [1.0.0] — 2025-09-01

### Agregado
- Versión inicial del Dashboard Backlog Incidentes TI
- Carga de archivos CSV mediante interfaz web
- Procesamiento de datos con PapaParse
- Visualización básica con Chart.js
- Hosting en GitHub Pages
- Documentación inicial (README)

---

## Convenciones de Versión

- **Major (X.0.0)**: Cambios de arquitectura o funcionalidad principal
- **Minor (0.X.0)**: Nuevas características o mejoras significativas
- **Patch (0.0.X)**: Correcciones de bugs y ajustes menores
