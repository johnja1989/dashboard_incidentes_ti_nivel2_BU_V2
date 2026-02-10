# Diccionario de Datos — Dashboard Backlog Incidentes TI

## Banco Unión S.A. — Vicepresidencia de Tecnología

---

## 📋 Origen de los Datos

| Aspecto | Detalle |
|---|---|
| **Archivo fuente** | `EST_VPT_BackLog_Incidentes_BU_V001_20250812.xlsx` |
| **Pestaña utilizada** | `Backlog Incidentes TI` |
| **Ubicación** | SharePoint — Vicepresidencia de Tecnología |
| **Formato de exportación** | CSV (delimitado por comas, codificación Windows-1252) |
| **Responsable de actualización** | Equipo de Gestión de Incidentes Nivel 2 |

---

## 📊 Columnas del Dataset

### Columnas Principales

| # | Nombre en Excel | Tipo | Requerido | Descripción | Valores ejemplo |
|---|---|---|---|---|---|
| 1 | `ID_INC` | Entero | Sí | Identificador secuencial único del registro en el backlog | 1, 2, 3, ... |
| 2 | `Nro Incidente` | Texto | Sí | Número del incidente en el sistema de tickets (puede incluir prefijos) | 138648, GYF-518, ID 33189 |
| 3 | `Caso Genial` | Texto | No | Número del caso en la plataforma Genial (sistema de gestión) | 2403040050, 2301020688, N/A |
| 4 | `Estado Final Incidente` | Texto | Sí | Estado actual del incidente | `Abierto`, `Cerrado` |
| 5 | `Fecha Última Actualización` | Fecha | No | Fecha de la última modificación o seguimiento del incidente | 18/07/2025, 10/10/2025 |
| 6 | `Seguimiento BU` | Texto largo | No | Detalle del seguimiento realizado por Banco Unión. Incluye fecha y descripción de acciones | "18/07/2025 Se realizó paso a producción el día 17 de julio, con pruebas exitosas" |

### Columnas Complementarias (presentes en el Excel completo)

| # | Nombre en Excel | Tipo | Descripción |
|---|---|---|---|
| 7 | `Ingeniero Asignado` | Texto | Nombre del ingeniero/analista responsable del incidente |
| 8 | `Edad Incidente` | Entero | Número de días desde la apertura del incidente |
| 9 | `Rango_Edad` | Texto | Clasificación del tiempo de vida del incidente |
| 10 | `Servicio` | Texto | Tipificación del servicio o categoría de TI afectado |
| 11 | `Proveedor a escalar` | Texto | Nombre del proveedor al que se escala el incidente |
| 12 | `Prioridad` | Texto | Nivel de prioridad del incidente |
| 13 | `Descripción` | Texto largo | Descripción detallada del incidente |

---

## 🔑 Campos Clave para el Dashboard

### Detección Automática de Columnas

El dashboard utiliza un sistema de **inferencia de schema** que busca coincidencias parciales en los nombres de las columnas. Esto permite flexibilidad si los encabezados cambian ligeramente.

| Métrica del Dashboard | Columnas que busca (por orden de prioridad) |
|---|---|
| **Estado** | `Estado Final Incidente`, `Estado`, `Status`, `State` |
| **Responsable** | `Ingeniero Asignado`, `Responsable`, `Asignado`, `Assigned` |
| **Tiempo/Edad** | `Edad Incidente`, `Edad`, `Días`, `Days`, `Tiempo`, `Duración` |
| **Rango de Edad** | `Rango_Edad`, `Rango Edad`, `Rango`, `Range` |
| **Servicio** | `Servicio`, `Tipificación`, `Categoría`, `Service`, `Category` |
| **Proveedor** | `Proveedor a escalar`, `Proveedor`, `Vendor`, `Provider` |

---

## 📊 Valores Esperados por Campo

### Estado Final Incidente

| Valor | Significado | Color en Dashboard |
|---|---|---|
| `Abierto` | Incidente en proceso, sin resolución | Rojo / Naranja |
| `Cerrado` | Incidente resuelto y verificado | Verde / Azul |

### Rango_Edad (si aplica)

| Valor | Rango | Criticidad |
|---|---|---|
| `< 7 días` | 0-6 días | Excelente |
| `7-15 días` | 7-15 días | Bueno |
| `15-30 días` | 16-30 días | Regular |
| `> 30 días` | 31+ días | Crítico |

### Ingeniero Asignado

Nombre completo del ingeniero o analista de TI responsable. Valores típicos:
- Nombre y apellido del ingeniero
- `N/A` si no está asignado
- Puede incluir múltiples formatos de nombre

### Proveedor a escalar

Nombre del proveedor externo. Valores típicos:
- Nombre comercial del proveedor (Oracle, Microsoft, Cisco, etc.)
- `N/A` si no aplica escalamiento
- `Interno` si se maneja sin proveedor externo

---

## 📅 Formatos de Fecha

El sistema acepta múltiples formatos de fecha:

| Formato | Ejemplo | Notas |
|---|---|---|
| `DD/MM/YYYY` | 18/07/2025 | Formato estándar Bolivia |
| `MM/DD/YYYY` | 07/18/2025 | Formato US (detectado automáticamente) |
| `YYYY-MM-DD` | 2025-07-18 | Formato ISO |
| `DD-MM-YYYY` | 18-07-2025 | Variante con guiones |

---

## 🔄 Reglas de Transformación

### Al exportar desde Excel a CSV

1. **Codificación**: Windows-1252 (CP1252) preferida; UTF-8 con BOM como alternativa
2. **Separador**: Coma (`,`)
3. **Encabezados**: Primera fila del CSV debe contener los nombres de las columnas
4. **Filas vacías**: Se filtran automáticamente al cargar
5. **Valores nulos**: `N/A`, vacío, o `null` son tratados como "sin dato"
6. **Texto con comas**: Debe estar entre comillas dobles (`"texto, con coma"`)

### Al procesar en el Dashboard

1. Se eliminan filas completamente vacías
2. Se normalizan espacios en blanco al inicio/final
3. Los caracteres especiales (ñ, acentos) se decodifican desde Windows-1252
4. Las fechas se parsean independientemente del formato

---

## 📈 Métricas Calculadas

El dashboard calcula automáticamente las siguientes métricas a partir de los datos:

| Métrica | Fórmula | Descripción |
|---|---|---|
| Total Incidentes | `COUNT(*)` | Total de filas con datos válidos |
| Abiertos | `COUNT(Estado = 'Abierto')` | Incidentes sin resolver |
| Cerrados | `COUNT(Estado = 'Cerrado')` | Incidentes resueltos |
| Tasa de Resolución | `Cerrados / Total * 100` | Porcentaje de resolución |
| Tiempo Promedio | `AVG(Edad Incidente)` | Media de días de todos los incidentes |
| Tiempo Mínimo | `MIN(Edad Incidente)` | Menor tiempo registrado |
| Tiempo Máximo | `MAX(Edad Incidente)` | Mayor tiempo registrado |
| Top Responsables | `GROUP BY Ingeniero → COUNT` | Ranking por volumen de casos |
| Top Servicios | `GROUP BY Servicio → COUNT` | Ranking por incidentes |
| Top Proveedores | `GROUP BY Proveedor → COUNT` | Ranking de escalamientos |

---

## ⚠️ Consideraciones de Calidad de Datos

| Problema común | Impacto | Solución |
|---|---|---|
| Nombres de ingenieros inconsistentes (ej: "Juan Pérez" vs "J. Pérez") | Duplicados en gráficos | Estandarizar en el Excel fuente |
| Estado con valores no estándar (ej: "En Proceso") | No se clasifica como Abierto/Cerrado | Usar solo "Abierto" o "Cerrado" |
| Edad del incidente vacía | No aparece en análisis temporal | Rellenar con el cálculo real de días |
| Proveedor vacío vs "N/A" | Conteo inconsistente | Usar "N/A" consistentemente |

---

## 📝 Pestañas del Excel Fuente

El archivo `EST_VPT_BackLog_Incidentes_BU_V001_20250812.xlsx` contiene múltiples pestañas:

| Pestaña | Usada por el Dashboard | Descripción |
|---|---|---|
| `LISTAS` | No | Listas de valores permitidos |
| `Tablas` | No | Tablas de referencia |
| `Tablero de Control` | No | Tablero interno del Excel |
| **`Backlog Incidentes TI`** | **Sí** | **Datos principales del backlog** |
| `Prioridades Diarias` | No | Gestión diaria de prioridades |
| `ppt Operaciones` | No | Datos para presentaciones |
| `complemento Operaciones` | No | Datos complementarios |

> **Importante**: Solo la pestaña `Backlog Incidentes TI` se exporta y consume por el dashboard.

---

**Última actualización**: 10 de febrero de 2026  
**Autor**: John Jairo Vargas González — Vicepresidencia de Tecnología
