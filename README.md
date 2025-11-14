# Base Repository

Repositorio base reutilizable con configuración de CI/CD, templates de GitHub, y estructura de ramas.

## 🚀 Inicio Rápido

### Crear una Nueva Rama

Usa los scripts helper para crear ramas siguiendo las convenciones:

```bash
# Crear feature
./scripts/new-feature.sh frontend login-google
./scripts/new-feature.sh backend api-authentication

# Crear bugfix
./scripts/new-bugfix.sh frontend login-error-500

# Crear refactor
./scripts/new-refactor.sh backend auth-service

# Crear hotfix
./scripts/new-hotfix.sh backend security-patch
```

Ver [documentación de scripts](./scripts/README.md) para más detalles.

### Crear Commits

Usa el script helper o deja que Cursor genere commits automáticamente (ya configurado con Conventional Commits):

```bash
# Script helper
./scripts/commit.sh feat frontend "agregar login con Google"

# O usa Cursor - respetará automáticamente el formato gracias a .cursorrules
```

## 📚 Documentación

- [Estrategia de Ramas](./docs/BRANCH_STRATEGY.md) - Estructura y flujo de trabajo
- [Protección de Ramas](./docs/BRANCH_PROTECTION.md) - Configuración de Branch Protection
- [Configuración de Vercel](./docs/VERCEL_CONFIG.md) - Evitar auto-deploy innecesario

## 🏗️ Estructura

```
base/
├── .github/          # Configuración de GitHub (workflows, templates)
├── backend/          # Código del backend
├── frontend/          # Código del frontend
├── docs/              # Documentación del proyecto
├── scripts/           # Scripts helper para crear ramas
└── README.md
```

## 🔧 Configuración

1. Clona el repositorio
2. Configura Branch Protection Rules según [BRANCH_PROTECTION.md](./docs/BRANCH_PROTECTION.md)
3. Configura la validación de nombres de ramas (el workflow ya está incluido)
4. Personaliza los workflows según tu plataforma de deploy
5. Configura Vercel según [VERCEL_CONFIG.md](./docs/VERCEL_CONFIG.md) si usas Vercel

## ✅ Validación Automática

El repositorio incluye validación automática del formato de nombres de ramas:

- ✅ Las ramas deben seguir el formato: `tipo/equipo/nombre-descriptivo`
- ❌ Si no cumple el formato, el PR será bloqueado
- 💡 Usa los scripts helper para evitar errores: `./scripts/new-feature.sh frontend login-google`

## 📝 Convenciones

- **Ramas**: `tipo/equipo/nombre-descriptivo`
  - Ejemplos: `feature/frontend/login-google`, `bugfix/backend/api-timeout`
- **Equipos**: `frontend`, `backend`
- **Tipos**: `feature`, `bugfix`, `refactor`, `hotfix`, `release`
