# Base Repository

Configuración base para proyectos con CI/CD, templates de GitHub y estructura de ramas.

## 🚀 Inicio Rápido

### Ramas Principales

- `main` - Producción
- `staging` - QA
- `dev-frontend` - Desarrollo frontend
- `dev-backend` - Desarrollo backend

### Scripts Opcionales

Si prefieres usar scripts helper (opcionales si usas GitHub Projects):

```bash
./scripts/new-feature.sh frontend login-google
./scripts/new-bugfix.sh backend api-timeout
```

Ver [scripts/README.md](./scripts/README.md) para más detalles.

## 📚 Documentación

- [Estrategia de Ramas](./docs/BRANCH_STRATEGY.md)
- [Configuración de Vercel](./docs/VERCEL_CONFIG.md)

## 🔧 Configuración Mínima

1. Clona el repositorio
2. Personaliza según las necesidades de tu equipo

## 📝 Convenciones (Opcionales)

- **Ramas**: `tipo/equipo/nombre` (ej: `feature/frontend/login`)
- **Equipos**: `frontend`, `backend`
- **Tipos**: `feature`, `bugfix`, `refactor`, `hotfix`, `release`

**Nota:** Estas son recomendaciones. El equipo puede ajustarlas según sus necesidades.
