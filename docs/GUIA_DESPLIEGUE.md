# 🚀 Guía Completa de Despliegue en GitHub Pages

## Paso 1: Crear Cuenta en GitHub (si no tienes)

1. Ve a [github.com](https://github.com)
2. Click en "Sign up"
3. Completa el registro con tu email
4. Verifica tu email

---

## Paso 2: Crear el Repositorio

### Opción A: Desde la Web (Más Fácil)

1. **Inicia sesión** en GitHub
2. Click en el **botón "+"** (arriba derecha) > "New repository"
3. **Completa el formulario**:
   ```
   Repository name: dashboard-incidentes-ti
   Description: Dashboard de gestión de incidentes TI
   ✅ Public (o Private si tienes GitHub Pro)
   ✅ Add a README file (desmarcar, lo subiremos nosotros)
   ```
4. Click en **"Create repository"**

---

## Paso 3: Subir los Archivos

### Método 1: Arrastra y Suelta (Más Fácil)

1. En tu repositorio nuevo, verás una pantalla vacía
2. Click en **"uploading an existing file"**
3. **Arrastra los archivos principales** desde tu computadora:
   ```
   ✅ index.html        (Dashboard principal - single-file app)
   ✅ LOGO.png           (Logo corporativo)
   ✅ robots.txt         (Control de indexación)
   ✅ README.md          (Documentación)
   ✅ CHANGELOG.md       (Historial de versiones)
   ✅ SECURITY.md        (Política de seguridad)
   ✅ LICENSE            (Licencia de uso)
   ✅ .gitignore         (Exclusiones de Git)
   ✅ sync_dashboard.ps1 (Script de sincronización)
   ```
4. En "Commit changes":
   ```
   Commit message: Initial commit - Dashboard Incidentes TI v1.5.0
   ```
5. Click en **"Commit changes"**
6. Repite para subir la carpeta `docs/` y `.github/workflows/`

### Método 2: Subir Archivo por Archivo

1. En tu repositorio, click en **"Add file"** > **"Upload files"**
2. Selecciona o arrastra cada archivo
3. Click en **"Commit changes"**

---

## Paso 4: Activar GitHub Pages

> **Nota**: Este proyecto utiliza una arquitectura single-file. Todo el código
> (HTML, CSS, JavaScript) está contenido en `index.html`. No es necesario
> renombrar ni duplicar archivos.

---

## Paso 5: Activar GitHub Pages

1. En tu repositorio, click en **"Settings"** (pestaña arriba)
2. En el menú izquierdo, click en **"Pages"**
3. En **"Source"**:
   ```
   Branch: main (o master)
   Folder: / (root)
   ```
4. Click en **"Save"**
5. **Espera 1-2 minutos**
6. Refresca la página
7. Verás un mensaje verde:
   ```
   ✅ Your site is published at https://tu-usuario.github.io/dashboard-incidentes-ti/
   ```

---

## Paso 6: Verificar que Funciona

1. **Click en el link** que aparece en GitHub Pages
2. Deberías ver tu dashboard
3. **Prueba cargar un CSV** para verificar

### Si no carga:

- Verifica que el archivo se llame exactamente `index.html`
- Espera 2-3 minutos más (GitHub Pages puede tardar)
- Refresca con Ctrl+F5
- Revisa la consola del navegador (F12)

---

## Paso 7: Actualizar el Dashboard

### Cuando necesites cambiar algo:

1. En GitHub, ve al archivo que quieres editar
2. Click en el **ícono de lápiz** (Edit)
3. Haz los cambios
4. Scroll abajo, click en **"Commit changes"**
5. **Espera 1-2 minutos** y el sitio se actualizará automáticamente

### Para actualizar datos.csv (uso diario):

1. En tu repositorio, click en **"Add file"** > **"Upload files"**
2. Arrastra tu nuevo CSV (o crea uno llamado `datos.csv`)
3. Click en **"Commit changes"**

**O mejor:** Los usuarios cargan el CSV directamente desde el dashboard (recomendado)

---

## 🔒 Configuración de Privacidad

### Hacer el Repositorio Privado

Si tienes **GitHub Pro** o **GitHub Enterprise**:

1. Ve a **"Settings"**
2. Scroll hasta **"Danger Zone"**
3. Click en **"Change visibility"**
4. Selecciona **"Make private"**
5. Confirma

> ⚠️ **Nota**: GitHub Pages en repos privados solo está disponible con GitHub Pro ($4/mes)

### Alternativa: Repositorio Público Pero Ofuscado

Si no tienes GitHub Pro:

1. Mantén el repo público
2. Usa un nombre de repositorio no obvio (ej: `rpt-stat-v2`)
3. No incluyas información sensible en el código
4. Los datos solo existen cuando el usuario carga el CSV

---

## 📊 Estructura Final del Repositorio

Tu repositorio debería verse así:

```
dashboard_incidentes_ti_nivel2_BU_V2/
├── index.html              ✅ Dashboard principal (single-file app)
├── LOGO.png                ✅ Logo corporativo
├── datos.zip               ✅ Datos CSV comprimidos (auto-generado)
├── robots.txt              ✅ Control de indexación
├── sync_dashboard.ps1      ✅ Script de sincronización automática
├── .gitignore              ✅ Exclusiones de Git
├── README.md               ✅ Documentación principal
├── CHANGELOG.md            ✅ Historial de versiones
├── SECURITY.md             ✅ Política de seguridad
├── LICENSE                 ✅ Licencia de uso interno
├── .github/workflows/      ✅ GitHub Actions
│   └── sync-sharepoint.yml
└── docs/                   ✅ Documentación detallada
    ├── GUIA_DESPLIEGUE.md
    ├── GUIA_SINCRONIZACION.md
    ├── REPORTES_EJECUTIVOS.md
    ├── CHECKLIST_ENTREGA.md
    └── DICCIONARIO_DATOS.md
```

---

## 🎯 URL Final

Tu dashboard estará disponible en:

```
https://johnja1989.github.io/dashboard_incidentes_ti_nivel2_BU_V2/
```

---

## 🔄 Actualización de Datos

### Método Recomendado: Sincronización Automática

El proyecto incluye un script PowerShell que automatiza todo el proceso:

```powershell
# Configuración inicial (una sola vez)
Install-Module ImportExcel -Scope CurrentUser
[Environment]::SetEnvironmentVariable("DASHBOARD_GITHUB_PAT", "ghp_TU_TOKEN", "User")

# Instalar tarea automática cada 30 minutos
.\sync_dashboard.ps1 -InstallScheduledTask -IntervalMinutes 30
```

> Para detalles completos, ver [GUIA_SINCRONIZACION.md](GUIA_SINCRONIZACION.md)

### Método Manual (alternativo)

1. Los usuarios abren el dashboard
2. Click en "📂 Cargar CSV"
3. Seleccionan el archivo CSV exportado desde el Excel
4. Los datos se actualizan automáticamente
5. Click en "🚀 Publicar a GitHub" para compartir

---

## 🐛 Solución de Problemas Comunes

### "404 - There isn't a GitHub Pages site here"

✅ **Solución:**
- Verifica que GitHub Pages esté activado en Settings > Pages
- Asegúrate de que el archivo se llame `index.html`
- Espera 2-3 minutos después de activar

### "El sitio carga pero está en blanco"

✅ **Solución:**
- Abre la consola del navegador (F12)
- Busca errores en rojo
- Verifica que `index.html` esté en la raíz del repositorio
- Verifica que las CDN de Chart.js, PapaParse, etc. cargan correctamente
- Refresca con Ctrl+F5

### "Los acentos se ven mal"

✅ **Solución:**
- El CSV debe estar en codificación Windows-1252
- Al exportar desde Excel, usa "CSV (delimitado por comas)"
- El dashboard lo maneja automáticamente

---

## 📞 Contacto y Soporte

**Desarrollador:** John Jairo Vargas González  
**Email:** john.vargas@bancounion.com

---

## ✅ Checklist Final

Antes de entregar, verifica:

- [ ] Repositorio creado en GitHub
- [ ] `index.html` y `LOGO.png` subidos a la raíz
- [ ] `.gitignore` activo (no se suben tokens ni logs)
- [ ] GitHub Pages activado (Settings > Pages > main > root)
- [ ] URL funcionando
- [ ] Dashboard carga correctamente
- [ ] Se puede cargar un CSV de prueba
- [ ] Los gráficos se generan bien
- [ ] El PDF funciona
- [ ] README.md tiene la URL correcta

---

**¡Listo para producción!** 🎉
