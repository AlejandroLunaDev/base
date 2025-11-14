# Configuración de Protección de Ramas

Este documento explica cómo configurar las Branch Protection Rules en GitHub para asegurar que el CI pase y se requiera revisión humana antes de hacer merge.

## ¿Por qué es importante?

- **Revisión humana obligatoria**: Asegura que un desarrollador revise el código antes de mergear
- **CI debe pasar**: Bloquea el merge si el CI falla
- **Protege ramas críticas**: Evita que se rompa `main` o `staging` accidentalmente

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
     - `Frontend CI`
     - `Backend CI`

   ✅ **Require conversation resolution before merging** (opcional, pero recomendado)

   ✅ **Do not allow bypassing the above settings** (recomendado para producción)
   
   ⚠️ **NO marques "Allow force pushes"** - Esto permitiría sobrescribir el historial
   ⚠️ **NO marques "Allow deletions"** - Esto permitiría borrar la rama main

6. Haz clic en "Create"

### Para la rama `staging` (QA)

Repite los mismos pasos pero con el patrón: `staging`

Puedes ser un poco más flexible:
- Require approvals: `1`
- Los mismos checks de CI

### Para las ramas de desarrollo (`dev-frontend`, `dev-backend`)

Opcional, pero recomendado:
- ✅ Require status checks to pass before merging
- ❌ No requerir aprobaciones (para desarrollo más ágil)

### Forzar Formato de Nombres de Ramas

Para bloquear ramas que no cumplan con el formato requerido:

1. Ve a Settings → Branches
2. Haz clic en "Add rule"
3. En "Branch name pattern", escribe: `*` (para todas las ramas excepto las principales)
4. Configura:
   - ✅ **Require status checks to pass before merging**
     - Selecciona: `Validate Branch Name` (el workflow que valida el formato)
   - ⚠️ **Opcional**: También puedes usar "Restrict who can push to matching branches" para mayor control

**Resultado**: 
- Las ramas que no cumplan el formato `tipo/equipo/nombre` fallarán el check
- No se podrá mergear hasta que se corrija el nombre de la rama
- El workflow mostrará un mensaje claro explicando el formato requerido

**Nota**: El workflow `validate-branch-name.yml` ya está configurado para validar automáticamente el formato de las ramas.

## Flujo de trabajo resultante

### Pull Request a `dev-frontend` o `dev-backend`:

```
1. Desarrollador crea PR
   ↓
2. CI se ejecuta automáticamente
   ↓
3. Si CI pasa ✅ → PR queda listo para merge
   ↓
4. Si CI falla ❌ → PR bloqueado, no se puede mergear
   ↓
5. Desarrollador revisa y corrige
   ↓
6. Humano hace merge manualmente (sin aprobación requerida en dev)
```

### Pull Request a `staging` o `main`:

```
1. Desarrollador crea PR
   ↓
2. CI se ejecuta automáticamente
   ↓
3. Si CI pasa ✅ → PR queda listo para revisión
   ↓
4. Revisor humano revisa el código
   ↓
5. Si aprueba ✅ → PR queda listo para merge
   ↓
6. Si CI falla ❌ → PR bloqueado, no se puede mergear
   ↓
7. Humano hace merge manualmente (solo si CI pasa y hay aprobación)
```

## Verificación

Después de configurar, cuando alguien intente mergear un PR:

- Si el CI no ha pasado: Verás un mensaje "Required status checks must pass"
- Si no hay aprobaciones: Verás "Review required"
- Solo cuando ambos pasen: El botón "Merge" estará habilitado

## Notas importantes

- El CI **NUNCA** mergea automáticamente
- El merge siempre lo hace un humano
- El CI solo **verifica** que el código funcione
- Las Branch Protection Rules **bloquean** el merge si no se cumplen los requisitos
- **NO se permite push directo a `main`** - Solo merge desde PRs
- Esto asegura que todo código pase por revisión y CI antes de llegar a producción

