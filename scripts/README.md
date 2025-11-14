# Scripts Helper para Crear Ramas

Scripts útiles para crear ramas siguiendo las convenciones del proyecto.

## Scripts Disponibles

### `new-feature.sh` - Crear rama de feature

Crea una nueva rama feature con formato: `feature/equipo/nombre-feature`

**Uso:**
```bash
./scripts/new-feature.sh [frontend|backend|ux-ui] nombre-feature
```

**Ejemplos:**
```bash
# Feature de frontend
./scripts/new-feature.sh frontend login-google

# Feature de backend
./scripts/new-feature.sh backend api-authentication

# Feature de UX/UI
./scripts/new-feature.sh ux-ui dashboard-redesign
```

**Resultado:**
- Crea la rama desde `dev-frontend` (si es frontend o ux-ui)
- Crea la rama desde `dev-backend` (si es backend)
- Formato: `feature/frontend/login-google`

---

### `new-bugfix.sh` - Crear rama de bugfix

Crea una nueva rama bugfix con formato: `bugfix/equipo/nombre-bugfix`

**Uso:**
```bash
./scripts/new-bugfix.sh [frontend|backend|ux-ui] nombre-bugfix
```

**Ejemplos:**
```bash
# Bugfix de frontend
./scripts/new-bugfix.sh frontend login-error-500

# Bugfix de backend
./scripts/new-bugfix.sh backend api-timeout

# Bugfix de UX/UI
./scripts/new-bugfix.sh ux-ui mobile-menu-overlap
```

**Resultado:**
- Crea la rama desde `dev-frontend` (si es frontend o ux-ui)
- Crea la rama desde `dev-backend` (si es backend)
- Formato: `bugfix/frontend/login-error-500`

---

### `new-refactor.sh` - Crear rama de refactor

Crea una nueva rama refactor con formato: `refactor/equipo/nombre-refactor`

**Uso:**
```bash
./scripts/new-refactor.sh [frontend|backend|ux-ui] nombre-refactor
```

**Ejemplos:**
```bash
# Refactor de frontend
./scripts/new-refactor.sh frontend component-structure

# Refactor de backend
./scripts/new-refactor.sh backend auth-service

# Refactor de UX/UI
./scripts/new-refactor.sh ux-ui layout-optimization
```

**Resultado:**
- Crea la rama desde `dev-frontend` (si es frontend o ux-ui)
- Crea la rama desde `dev-backend` (si es backend)
- Formato: `refactor/frontend/component-structure`
- ⚠️ **NOTA**: Los refactors mejoran el código sin cambiar funcionalidad

---

### `new-hotfix.sh` - Crear rama de hotfix

Crea una nueva rama hotfix con formato: `hotfix/equipo/nombre-hotfix`

**Uso:**
```bash
./scripts/new-hotfix.sh [frontend|backend|ux-ui] nombre-hotfix
```

**Ejemplos:**
```bash
# Hotfix de frontend
./scripts/new-hotfix.sh frontend security-patch

# Hotfix de backend
./scripts/new-hotfix.sh backend payment-gateway-fix
```

**Resultado:**
- Crea la rama desde `main` (producción)
- Formato: `hotfix/frontend/security-patch`
- ⚠️ **IMPORTANTE**: Los hotfixes se crean desde main y deben mergearse a main, staging y la rama de desarrollo correspondiente

---

## Equipos Válidos

- `frontend` - Para features/bugfixes del frontend
- `backend` - Para features/bugfixes del backend
- `ux-ui` - Para features/bugfixes de diseño/UX

## Permisos de Ejecución

Si los scripts no tienen permisos de ejecución, ejecuta:

```bash
chmod +x scripts/*.sh
```

O en Windows con Git Bash, los scripts deberían funcionar directamente.

## Convenciones de Nombres

Los nombres de features/bugfixes deben:
- ✅ Usar minúsculas
- ✅ Separar palabras con guiones (`-`)
- ✅ Ser descriptivos pero concisos
- ❌ No usar espacios ni caracteres especiales

**Ejemplos buenos:**
- `login-google`
- `user-profile-page`
- `api-authentication`

**Ejemplos malos:**
- `Login Google` ❌ (espacios)
- `login@v2` ❌ (caracteres especiales)
- `nueva-feature` ❌ (muy genérico)

## Flujo Completo

1. **Crear la rama:**
   ```bash
   ./scripts/new-feature.sh frontend login-google
   ```

2. **Desarrollar:**
   ```bash
   # Hacer cambios...
   git add .
   git commit -m "feat(frontend): implementar login con Google"
   ```

3. **Push y crear PR:**
   ```bash
   git push -u origin feature/frontend/login-google
   # Luego crear Pull Request en GitHub hacia dev-frontend
   ```

### `commit.sh` - Crear commits con formato Conventional Commits

Crea commits siguiendo el formato: `tipo(scope): descripción`

**Uso:**
```bash
# Modo interactivo (el script pregunta todo)
./scripts/commit.sh

# Modo con parámetros
./scripts/commit.sh [tipo] [scope] [descripción]
```

**Ejemplos:**
```bash
# Feature de frontend
./scripts/commit.sh feat frontend "agregar login con Google"

# Bugfix de backend
./scripts/commit.sh fix backend "corregir error 500 en API"

# Refactor
./scripts/commit.sh refactor frontend "reorganizar componentes"

# Modo interactivo (detecta scope automáticamente)
./scripts/commit.sh
# Te pregunta: tipo, scope, y descripción (TEXTO LIBRE)
```

**Tipos válidos:**
- `feat` - Nueva funcionalidad
- `fix` - Corrección de bug
- `refactor` - Refactorización
- `docs` - Documentación
- `style` - Formato (sin afectar código)
- `test` - Tests
- `chore` - Mantenimiento
- `perf` - Rendimiento
- `ci` - CI/CD
- `build` - Build system
- `revert` - Revertir commit

**Scopes válidos:**
- `frontend`, `backend`, `ux-ui`, `docs`, `ci`, `config`

**Características:**
- ✅ Detecta scope automáticamente según la carpeta donde estás
- ✅ Valida tipo y scope
- ✅ Modo interactivo si no proporcionas parámetros
- ✅ Preview del commit antes de crearlo
- ✅ La descripción es TEXTO LIBRE (el desarrollador escribe lo que quiere)

**Resultado:**
- Crea commit con formato: `feat(frontend): agregar login con Google`
- Listo para push y crear PR

---

## Troubleshooting

### Error: "No estás en un repositorio git"
- Asegúrate de estar en la raíz del proyecto

### Error: "La rama 'dev-frontend' no existe"
- La rama base debe existir en el remoto
- El script intentará obtenerla automáticamente

### Error: "La rama ya existe"
- La rama con ese nombre ya existe localmente
- Usa otro nombre o elimina la rama existente

