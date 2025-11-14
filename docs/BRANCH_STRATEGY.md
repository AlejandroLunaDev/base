# Estrategia de Ramas

## Estructura de Ramas

Este proyecto utiliza una estrategia de ramas basada en Git Flow con las siguientes ramas principales:

### Ramas Principales

- **`main`**: Rama de producción

  - Contiene el código estable y listo para producción
  - Solo se actualiza mediante merge desde `staging`
  - Protegida contra pushes directos

- **`staging`**: Rama de QA y pruebas

  - Contiene el código que está siendo probado antes de producción
  - Se actualiza mediante merge desde las ramas de desarrollo
  - Permite realizar pruebas de integración y QA

- **`dev-frontend`**: Rama de desarrollo para Frontend

  - Rama principal de desarrollo para el frontend
  - Se actualiza mediante merge desde feature branches del frontend
  - Se mergea a `staging` cuando está listo para QA

- **`dev-backend`**: Rama de desarrollo para Backend
  - Rama principal de desarrollo para el backend
  - Se actualiza mediante merge desde feature branches del backend
  - Se mergea a `staging` cuando está listo para QA

## Flujo de Trabajo

### Desarrollo de Features

1. Crear una rama feature desde la rama de desarrollo correspondiente:

   ```bash
   # Para frontend
   git checkout dev-frontend
   git checkout -b feature/nombre-feature

   # Para backend
   git checkout dev-backend
   git checkout -b feature/nombre-feature
   ```

2. Desarrollar y hacer commits en la rama feature

3. Crear Pull Request hacia la rama de desarrollo correspondiente (`dev-frontend` o `dev-backend`)

4. Después de revisión y aprobación, mergear a la rama de desarrollo

### Proceso hacia Staging

1. Cuando `dev-frontend` o `dev-backend` están listos para QA:

   ```bash
   git checkout staging
   git merge dev-frontend    # o dev-backend para backend
   ```

2. Crear Pull Request desde `dev-frontend`/`dev-backend` hacia `staging` para revisión

3. Después de pruebas en staging, si todo está correcto, proceder a producción

### Proceso hacia Producción

1. Cuando `staging` está listo para producción:

   ```bash
   git checkout main
   git merge staging
   ```

2. Crear Pull Request desde `staging` hacia `main` para revisión final

3. Después de aprobación, mergear y crear tag de versión

## Convenciones de Nombres

### Formato General

Las ramas deben seguir el formato: `tipo/equipo/nombre-descriptivo`

### Tipos de Ramas

- **Features**: `feature/equipo/nombre-descriptivo`
  - Ejemplos: `feature/frontend/login-google`, `feature/backend/api-auth`, `feature/ux-ui/dashboard-redesign`
- **Bugs**: `bugfix/equipo/nombre-descriptivo`
  - Ejemplos: `bugfix/frontend/login-error-500`, `bugfix/backend/api-timeout`
- **Refactors**: `refactor/equipo/nombre-descriptivo`
  - Ejemplos: `refactor/frontend/component-structure`, `refactor/backend/auth-service`
  - **Nota**: Mejora el código sin cambiar funcionalidad
- **Hotfixes**: `hotfix/equipo/nombre-descriptivo` (desde `main`)
  - Ejemplos: `hotfix/frontend/security-patch`, `hotfix/backend/payment-fix`
- **Releases**: `release/v1.0.0`
  - Ejemplos: `release/v1.2.0`, `release/v2.0.0`

### Equipos Válidos

- `frontend` - Para código del frontend
- `backend` - Para código del backend
- `ux-ui` - Para diseño y UX/UI

### Crear Ramas con Scripts Helper

Para facilitar la creación de ramas, usa los scripts helper en `scripts/`:

```bash
# Crear feature
./scripts/new-feature.sh frontend login-google

# Crear bugfix
./scripts/new-bugfix.sh backend api-timeout

# Crear refactor
./scripts/new-refactor.sh frontend component-structure

# Crear hotfix
./scripts/new-hotfix.sh frontend security-patch
```

Ver [documentación de scripts](../scripts/README.md) para más detalles.

### Validación Automática

GitHub Actions valida automáticamente que las ramas cumplan con el formato requerido. Si una rama no cumple el formato:

- ❌ El workflow `Validate Branch Name` fallará
- ❌ No se podrá mergear hasta corregir el nombre
- ✅ Se mostrará un mensaje con el formato correcto y ejemplos

**Para evitar problemas**: Usa siempre los scripts helper que garantizan el formato correcto.

## Protección de Ramas

- `main`: Requiere aprobación de revisores, no permite push directo
- `staging`: Requiere aprobación de revisores, no permite push directo
- `dev-frontend`/`dev-backend`: Permite push directo del equipo de desarrollo
