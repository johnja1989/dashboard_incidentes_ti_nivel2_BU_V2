# ðŸš€ GuÃ­a Completa de Despliegue en GitHub Pages

## Paso 1: Crear Cuenta en GitHub (si no tienes)

1. Ve a [github.com](https://github.com)
2. Click en "Sign up"
3. Completa el registro con tu email
4. Verifica tu email

---

## Paso 2: Crear el Repositorio

### OpciÃ³n A: Desde la Web (MÃ¡s FÃ¡cil)

1. **Inicia sesiÃ³n** en GitHub
2. Click en el **botÃ³n "+"** (arriba derecha) > "New repository"
3. **Completa el formulario**:
   ```
   Repository name: dashboard-incidentes-ti
   Description: Dashboard de gestiÃ³n de incidentes TI
   âœ… Public (o Private si tienes GitHub Pro)
   âœ… Add a README file (desmarcar, lo subiremos nosotros)
   ```
4. Click en **"Create repository"**

---

## Paso 3: Subir los Archivos

### MÃ©todo 1: Arrastra y Suelta (MÃ¡s FÃ¡cil)

1. En tu repositorio nuevo, verÃ¡s una pantalla vacÃ­a
2. Click en **"uploading an existing file"**
3. **Arrastra los archivos principales** desde tu computadora:
   ```
   âœ… index.html        (Dashboard principal - single-file app)
   âœ… LOGO.png           (Logo corporativo)
   âœ… robots.txt         (Control de indexaciÃ³n)
   âœ… README.md          (DocumentaciÃ³n)
   âœ… CHANGELOG.md       (Historial de versiones)
   âœ… SECURITY.md        (PolÃ­tica de seguridad)
   âœ… LICENSE            (Licencia de uso)
   âœ… .gitignore         (Exclusiones de Git)
   âœ… sync_dashboard.ps1 (Script de sincronizaciÃ³n)
   ```
4. En "Commit changes":
   ```
   Commit message: Initial commit - Dashboard Incidentes TI v1.5.0
   ```
5. Click en **"Commit changes"**
6. Repite para subir la carpeta `docs/` y `.github/workflows/`

### MÃ©todo 2: Subir Archivo por Archivo

1. En tu repositorio, click en **"Add file"** > **"Upload files"**
2. Selecciona o arrastra cada archivo
3. Click en **"Commit changes"**

---

## Paso 4: Activar GitHub Pages

> **Nota**: Este proyecto utiliza una arquitectura single-file. Todo el cÃ³digo
> (HTML, CSS, JavaScript) estÃ¡ contenido en `index.html`. No es necesario
> renombrar ni duplicar archivos.

---

## Paso 5: Activar GitHub Pages

1. En tu repositorio, click en **"Settings"** (pestaÃ±a arriba)
2. En el menÃº izquierdo, click en **"Pages"**
3. En **"Source"**:
   ```
   Branch: main (o master)
   Folder: / (root)
   ```
4. Click en **"Save"**
5. **Espera 1-2 minutos**
6. Refresca la pÃ¡gina
7. VerÃ¡s un mensaje verde:
   ```
   âœ… Your site is published at https://tu-usuario.github.io/dashboard-incidentes-ti/
   ```

---

## Paso 6: Verificar que Funciona

1. **Click en el link** que aparece en GitHub Pages
2. DeberÃ­as ver tu dashboard
3. **Prueba cargar un CSV** para verificar

### Si no carga:

- Verifica que el archivo se llame exactamente `index.html`
- Espera 2-3 minutos mÃ¡s (GitHub Pages puede tardar)
- Refresca con Ctrl+F5
- Revisa la consola del navegador (F12)

---

## Paso 7: Actualizar el Dashboard

### Cuando necesites cambiar algo:

1. En GitHub, ve al archivo que quieres editar
2. Click en el **Ã­cono de lÃ¡piz** (Edit)
3. Haz los cambios
4. Scroll abajo, click en **"Commit changes"**
5. **Espera 1-2 minutos** y el sitio se actualizarÃ¡ automÃ¡ticamente

### Para actualizar datos.csv (uso diario):

1. En tu repositorio, click en **"Add file"** > **"Upload files"**
2. Arrastra tu nuevo CSV (o crea uno llamado `datos.csv`)
3. Click en **"Commit changes"**

**O mejor:** Los usuarios cargan el CSV directamente desde el dashboard (recomendado)

---

## ðŸ”’ ConfiguraciÃ³n de Privacidad

### Hacer el Repositorio Privado

Si tienes **GitHub Pro** o **GitHub Enterprise**:

1. Ve a **"Settings"**
2. Scroll hasta **"Danger Zone"**
3. Click en **"Change visibility"**
4. Selecciona **"Make private"**
5. Confirma

> âš ï¸ **Nota**: GitHub Pages en repos privados solo estÃ¡ disponible con GitHub Pro ($4/mes)

### Alternativa: Repositorio PÃºblico Pero Ofuscado

Si no tienes GitHub Pro:

1. MantÃ©n el repo pÃºblico
2. Usa un nombre de repositorio no obvio (ej: `rpt-stat-v2`)
3. No incluyas informaciÃ³n sensible en el cÃ³digo
4. Los datos solo existen cuando el usuario carga el CSV

---

## ðŸ“Š Estructura Final del Repositorio

Tu repositorio deberÃ­a verse asÃ­:

```
dashboard_incidentes_ti_nivel2_BU_V2/
â”œâ”€â”€ index.html              âœ… Dashboard principal (single-file app)
â”œâ”€â”€ LOGO.png                âœ… Logo corporativo
â”œâ”€â”€ datos.zip               âœ… Datos CSV comprimidos (auto-generado)
â”œâ”€â”€ robots.txt              âœ… Control de indexaciÃ³n
â”œâ”€â”€ sync_dashboard.ps1      âœ… Script de sincronizaciÃ³n automÃ¡tica
â”œâ”€â”€ .gitignore              âœ… Exclusiones de Git
â”œâ”€â”€ README.md               âœ… DocumentaciÃ³n principal
â”œâ”€â”€ CHANGELOG.md            âœ… Historial de versiones
â”œâ”€â”€ SECURITY.md             âœ… PolÃ­tica de seguridad
â”œâ”€â”€ LICENSE                 âœ… Licencia de uso interno
â”œâ”€â”€ .github/workflows/      âœ… GitHub Actions
â”‚   â””â”€â”€ sync-sharepoint.yml
â””â”€â”€ docs/                   âœ… DocumentaciÃ³n detallada
    â”œâ”€â”€ GUIA_DESPLIEGUE.md
    â”œâ”€â”€ GUIA_SINCRONIZACION.md
    â”œâ”€â”€ REPORTES_EJECUTIVOS.md
    â”œâ”€â”€ CHECKLIST_ENTREGA.md
    â””â”€â”€ DICCIONARIO_DATOS.md
```

---

## ðŸŽ¯ URL Final

Tu dashboard estarÃ¡ disponible en:

```
https://johnja1989.github.io/dashboard_incidentes_ti_nivel2_BU_V2/
```

---

## ðŸ”„ ActualizaciÃ³n de Datos

### MÃ©todo Recomendado: SincronizaciÃ³n AutomÃ¡tica

El proyecto incluye un script PowerShell que automatiza todo el proceso:

```powershell
# ConfiguraciÃ³n inicial (una sola vez)
Install-Module ImportExcel -Scope CurrentUser
[Environment]::SetEnvironmentVariable("DASHBOARD_GITHUB_PAT", "ghp_TU_TOKEN", "User")

# Instalar tarea automÃ¡tica cada 30 minutos
.\sync_dashboard.ps1 -InstallScheduledTask -IntervalMinutes 30
```

> Para detalles completos, ver [GUIA_SINCRONIZACION.md](GUIA_SINCRONIZACION.md)

### MÃ©todo Manual (alternativo)

1. Los usuarios abren el dashboard
2. Click en "ðŸ“‚ Cargar CSV"
3. Seleccionan el archivo CSV exportado desde el Excel
4. Los datos se actualizan automÃ¡ticamente
5. Click en "ðŸš€ Publicar a GitHub" para compartir

---

## ðŸ› SoluciÃ³n de Problemas Comunes

### "404 - There isn't a GitHub Pages site here"

âœ… **SoluciÃ³n:**
- Verifica que GitHub Pages estÃ© activado en Settings > Pages
- AsegÃºrate de que el archivo se llame `index.html`
- Espera 2-3 minutos despuÃ©s de activar

### "El sitio carga pero estÃ¡ en blanco"

âœ… **SoluciÃ³n:**
- Abre la consola del navegador (F12)
- Busca errores en rojo
- Verifica que `index.html` estÃ© en la raÃ­z del repositorio
- Verifica que las CDN de Chart.js, PapaParse, etc. cargan correctamente
- Refresca con Ctrl+F5

### "Los acentos se ven mal"

âœ… **SoluciÃ³n:**
- El CSV debe estar en codificaciÃ³n Windows-1252
- Al exportar desde Excel, usa "CSV (delimitado por comas)"
- El dashboard lo maneja automÃ¡ticamente

---

## ðŸ“ž Contacto y Soporte

**Desarrollador:** John Jairo Vargas GonzÃ¡lez  
**Email:** john.vargas@bancounion.com

---

## âœ… Checklist Final

Antes de entregar, verifica:

- [ ] Repositorio creado en GitHub
- [ ] `index.html` y `LOGO.png` subidos a la raÃ­z
- [ ] `.gitignore` activo (no se suben tokens ni logs)
- [ ] GitHub Pages activado (Settings > Pages > main > root)
- [ ] URL funcionando
- [ ] Dashboard carga correctamente
- [ ] Se puede cargar un CSV de prueba
- [ ] Los grÃ¡ficos se generan bien
- [ ] El PDF funciona
- [ ] README.md tiene la URL correcta

---

**Â¡Listo para producciÃ³n!** ðŸŽ‰
