# Estrategia de Ramas

Estrategia simple basada en Git Flow adaptada para equipos de frontend y backend.

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

## Flujo de Trabajo Simple

1. **Crear rama feature** desde `dev-frontend` o `dev-backend`
2. **Desarrollar** y hacer commits
3. **Crear Pull Request** hacia la rama de desarrollo correspondiente
4. **Mergear** después de revisión

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

## Convenciones de Nombres (Opcionales)

Formato recomendado: `tipo/equipo/nombre`

**Tipos:** `feature`, `bugfix`, `refactor`, `hotfix`, `release`  
**Equipos:** `frontend`, `backend`

**Ejemplos:**
- `feature/frontend/login-google`
- `bugfix/backend/api-timeout`
- `hotfix/frontend/security-patch`

**Nota:** Estas son recomendaciones. El equipo puede ajustarlas según sus necesidades. Las ramas se crean desde GitHub Projects.
