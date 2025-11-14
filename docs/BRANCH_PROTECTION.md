# Protección de Ramas

Configuración opcional de Branch Protection Rules en GitHub para proteger ramas críticas.

**Beneficios:**
- Requiere revisión antes de mergear
- Asegura que el CI pase
- Protege `main` y `staging` de cambios accidentales

## Cómo configurar Branch Protection Rules

### Para la rama `main` (Producción)

1. Ve a tu repositorio en GitHub
2. Settings → Branches
3. En "Branch protection rules", haz clic en "Add rule"
4. En "Branch name pattern", escribe: `main`
5. Configura las siguientes opciones:

   ✅ **Require a pull request before merging**
   - ✅ Require approvals: `1` (o el número que prefieras)
   - ✅ Dismiss stale pull request approvals when new commits are pushed
   - ✅ Require review from Code Owners (opcional)
   - ⚠️ **IMPORTANTE**: Esto bloquea push directo a main, solo permite merge desde PRs

   ✅ **Require status checks to pass before merging**
   - ✅ Require branches to be up to date before merging
   - En "Status checks that are required", selecciona:
     - `CI (frontend)`
     - `CI (backend)`

   ✅ **Require conversation resolution before merging** (opcional, pero recomendado)

   ✅ **Do not allow bypassing the above settings** (recomendado para producción)
   
   ⚠️ **NO marques "Allow force pushes"** - Esto permitiría sobrescribir el historial
   ⚠️ **NO marques "Allow deletions"** - Esto permitiría borrar la rama main

6. Haz clic en "Create"

### Para `staging` (QA)

Misma configuración que `main`, pero puede ser más flexible (1 aprobación).

### Para `dev-frontend` y `dev-backend`

Opcional: Solo requerir que el CI pase, sin aprobaciones obligatorias.

### Nota sobre Validación de Nombres de Ramas

La validación de nombres de ramas se puede hacer de forma local usando herramientas como [Husky](https://typicode.github.io/husky/) para evitar consumir recursos de GitHub Actions.

Si prefieres validaciones automáticas en GitHub, puedes configurar Branch Protection Rules, pero ten en cuenta que esto consume minutos de GitHub Actions, que es un recurso limitado.

## Flujo Resultante

**PRs a `dev-frontend`/`dev-backend`:**
- CI se ejecuta → Si pasa, se puede mergear (sin aprobación obligatoria)

**PRs a `staging`/`main`:**
- CI se ejecuta → Si pasa, requiere aprobación → Luego se puede mergear

**Nota:** El merge siempre lo hace un humano. El CI solo verifica que el código funcione.

