# Política de Seguridad — Dashboard Backlog Incidentes TI

## Banco Unión S.A. — Vicepresidencia de Tecnología

---

## 📋 Alcance

Este documento describe las prácticas de seguridad implementadas en el Dashboard Backlog Incidentes TI Nivel 2, un sistema web estático alojado en GitHub Pages para la visualización de datos operacionales de incidentes.

---

## 🔒 Arquitectura de Seguridad

### Procesamiento de Datos

| Aspecto | Implementación |
|---|---|
| **Ubicación del procesamiento** | 100% local en el navegador del usuario |
| **Envío a servidores externos** | No. Los datos no salen del navegador excepto para publicación autorizada a GitHub |
| **Almacenamiento en servidor** | Solo `datos.zip` (CSV comprimido) en GitHub como archivo público del repositorio |
| **Almacenamiento en cliente** | localStorage del navegador (caché para evitar recarga) |

### Transporte de Datos

| Canal | Protocolo | Cifrado |
|---|---|---|
| GitHub Pages → Navegador | HTTPS | TLS 1.2+ |
| Navegador → GitHub API | HTTPS | TLS 1.2+ |
| SharePoint → Script PowerShell | HTTPS (OneDrive local) | Disco cifrado por BitLocker |

### Autenticación

| Componente | Mecanismo |
|---|---|
| Dashboard (lectura) | Acceso público vía URL (no requiere autenticación) |
| Publicación a GitHub | GitHub Personal Access Token (PAT) con scope `repo` |
| Script PowerShell | PAT almacenado en variable de entorno o archivo local |

---

## 🛡️ Manejo de Credenciales

### GitHub Personal Access Token (PAT)

El PAT es necesario **únicamente para el administrador** que publica datos. Los lectores del dashboard no necesitan token.

#### Almacenamiento seguro del PAT

| Método | Ubicación | Riesgo |
|---|---|---|
| Variable de entorno del usuario | `$env:DASHBOARD_GITHUB_PAT` | Bajo — solo accesible por el usuario de Windows |
| Archivo `.github_pat` | Carpeta local del script | Bajo — excluido por `.gitignore` |
| localStorage del navegador | Navegador del admin | Medio — accesible por JavaScript en el mismo dominio |
| Parámetro de línea de comando | Terminal temporal | Bajo — visible solo durante la sesión |

#### Buenas prácticas

- **NUNCA** commitear el PAT al repositorio
- El archivo `.github_pat` está en `.gitignore` para prevenir subidas accidentales
- Usar PAT con el scope mínimo necesario (`repo`)
- Rotar (regenerar) el PAT cada 90 días
- Configurar fecha de expiración al crear el PAT en GitHub

#### Qué hacer si un PAT se expone

1. Revocar inmediatamente en [GitHub Settings → Developer settings → Personal access tokens](https://github.com/settings/tokens)
2. Generar un nuevo PAT
3. Actualizar la variable de entorno o archivo `.github_pat`
4. Revisar el historial de actividad del repositorio

---

## 📊 Clasificación de Datos

| Dato | Clasificación | Notas |
|---|---|---|
| N° de incidente | Interno | Identificador operacional |
| Caso Genial (ID externo) | Interno | Referencia a sistema de tickets |
| Nombre de ingeniero asignado | Interno | Datos de personal |
| Estado del incidente | Interno | Operacional |
| Servicio/categoría | Interno | Operacional |
| Proveedor escalado | Interno | Relación comercial |
| Seguimiento BU | Interno | Notas operacionales |
| Fechas de actualización | Interno | Operacional |

> **Nota**: El dashboard NO procesa ni almacena datos sensibles como números de cuenta, información de clientes, contraseñas o datos financieros.

---

## 🌐 Control de Acceso

### Repositorio Público

Si el repositorio es público:
- Cualquier persona con la URL puede ver el dashboard y los datos
- Los datos del CSV comprimido (`datos.zip`) son accesibles
- **Mitigación**: Los datos son operacionales internos, no sensibles

### Repositorio Privado (recomendado para producción)

Con GitHub Pro o GitHub Enterprise:
- Solo usuarios autorizados de la organización pueden acceder
- GitHub Pages sirve solo a usuarios autenticados
- Control de acceso granular por equipo/usuario

### Recomendaciones

1. Usar repositorio privado si la política corporativa lo requiere
2. No incluir datos de clientes o información financiera en el CSV
3. Para datos altamente sensibles, considerar solución on-premise

---

## 🔄 Seguridad en la Sincronización

### Script PowerShell (`sync_dashboard.ps1`)

- Lee archivos localmente desde OneDrive (no descarga de internet)
- El PAT viaja cifrado por HTTPS a la API de GitHub
- Los archivos temporales se eliminan después de cada ejecución
- El log (`sync_dashboard.log`) no registra tokens ni datos del CSV

### GitHub Actions (`sync-sharepoint.yml`)

- Los secretos de GitHub Actions están cifrados en reposo
- Las URLs de SharePoint se almacenan como secretos del repositorio
- Los logs de ejecución no exponen datos sensibles
- El workflow se ejecuta en un contenedor efímero (se destruye después)

### Botón "Sync SharePoint" (navegador)

- La URL de SharePoint se guarda en localStorage (solo en el navegador del admin)
- Si se usa proxy CORS, los datos pasan por el proxy (considerar confiabilidad)
- Recomendación: Preferir el script PowerShell para mayor seguridad

---

## 🐛 Reporte de Vulnerabilidades

Si encuentras una vulnerabilidad de seguridad en este proyecto:

1. **NO** la publiques en un Issue público
2. Contacta directamente al autor:
   - 📧 john.vargas@bancounion.com
   - Asunto: `[SEGURIDAD] Dashboard Incidentes TI`
3. Incluye:
   - Descripción de la vulnerabilidad
   - Pasos para reproducirla
   - Impacto potencial
4. Tiempo de respuesta esperado: 24-48 horas hábiles

---

## ✅ Checklist de Seguridad para el Administrador

- [ ] `.gitignore` incluye `.github_pat`, `*.log` y archivos sensibles
- [ ] El PAT de GitHub tiene scope mínimo (`repo` solamente)
- [ ] El PAT tiene fecha de expiración configurada
- [ ] El repositorio es privado (si aplica política corporativa)
- [ ] El CSV no contiene datos de clientes o financieros
- [ ] El script PowerShell se ejecuta con permisos mínimos (no admin)
- [ ] Las contraseñas de OneDrive/SharePoint no están en el código
- [ ] Se revisan los logs periódicamente (`sync_dashboard.log`)

---

## 📅 Revisión

Esta política debe ser revisada cada **6 meses** o cuando haya cambios significativos en la arquitectura.

| Fecha | Versión | Autor | Cambios |
|---|---|---|---|
| 2026-02-10 | 1.0 | John Jairo Vargas González | Versión inicial |

---

**Banco Unión S.A.** — Vicepresidencia de Tecnología  
*Documento de uso interno*
