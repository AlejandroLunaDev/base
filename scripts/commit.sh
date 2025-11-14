#!/bin/bash

# Script helper para crear commits con formato Conventional Commits
# Uso: ./scripts/commit.sh [tipo] [scope] [descripción]
# Ejemplo: ./scripts/commit.sh feat frontend "agregar login con Google"

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Tipos válidos de commits
VALID_TYPES=("feat" "fix" "refactor" "docs" "style" "test" "chore" "perf" "ci" "build" "revert")

# Scopes válidos
VALID_SCOPES=("frontend" "backend" "ux-ui" "docs" "ci" "config")

# Función para detectar scope automáticamente
detect_scope() {
  if [ -f "package.json" ] || [ -d "src" ] || [ -d "components" ]; then
    if [ -f "package.json" ]; then
      # Intentar detectar desde package.json o estructura
      if [ -d "../backend" ] && [ "$(pwd)" != "$(cd ../backend && pwd)" ]; then
        echo "frontend"
        return
      fi
    fi
  fi
  
  # Detectar desde el directorio actual
  CURRENT_DIR=$(pwd)
  if [[ "$CURRENT_DIR" == *"frontend"* ]]; then
    echo "frontend"
  elif [[ "$CURRENT_DIR" == *"backend"* ]]; then
    echo "backend"
  elif [[ "$CURRENT_DIR" == *"docs"* ]]; then
    echo "docs"
  else
    echo ""
  fi
}

# Función para validar tipo
validate_type() {
  local type=$1
  for valid_type in "${VALID_TYPES[@]}"; do
    if [ "$type" == "$valid_type" ]; then
      return 0
    fi
  done
  return 1
}

# Función para validar scope
validate_scope() {
  local scope=$1
  for valid_scope in "${VALID_SCOPES[@]}"; do
    if [ "$scope" == "$valid_scope" ]; then
      return 0
    fi
  done
  return 1
}

# Obtener parámetros
TYPE=$1
SCOPE=$2
DESCRIPTION=$3

# Modo interactivo si no se proporcionan todos los parámetros
if [ -z "$TYPE" ] || [ -z "$SCOPE" ] || [ -z "$DESCRIPTION" ]; then
  echo -e "${BLUE}📝 Crear commit con formato Conventional Commits${NC}"
  echo ""
  
  # Solicitar tipo
  if [ -z "$TYPE" ]; then
    echo -e "${YELLOW}Tipos disponibles:${NC}"
    echo "  feat     - Nueva funcionalidad"
    echo "  fix      - Corrección de bug"
    echo "  refactor - Refactorización de código"
    echo "  docs     - Cambios en documentación"
    echo "  style    - Cambios de formato (sin afectar código)"
    echo "  test     - Agregar o modificar tests"
    echo "  chore    - Tareas de mantenimiento"
    echo "  perf     - Mejoras de rendimiento"
    echo "  ci       - Cambios en CI/CD"
    echo "  build    - Cambios en build system"
    echo "  revert   - Revertir un commit anterior"
    echo ""
    read -p "Tipo de commit: " TYPE
  fi
  
  # Validar tipo
  if ! validate_type "$TYPE"; then
    echo -e "${RED}❌ Error: Tipo inválido '$TYPE'${NC}"
    echo "Tipos válidos: ${VALID_TYPES[*]}"
    exit 1
  fi
  
  # Solicitar scope
  if [ -z "$SCOPE" ]; then
    AUTO_SCOPE=$(detect_scope)
    if [ -n "$AUTO_SCOPE" ]; then
      echo -e "${GREEN}💡 Scope detectado automáticamente: $AUTO_SCOPE${NC}"
      read -p "Scope [$AUTO_SCOPE]: " SCOPE
      SCOPE=${SCOPE:-$AUTO_SCOPE}
    else
      echo -e "${YELLOW}Scopes disponibles:${NC}"
      echo "  frontend, backend, ux-ui, docs, ci, config"
      read -p "Scope: " SCOPE
    fi
  fi
  
  # Validar scope
  if ! validate_scope "$SCOPE"; then
    echo -e "${YELLOW}⚠️  Advertencia: Scope '$SCOPE' no está en la lista recomendada${NC}"
    echo "Scopes recomendados: ${VALID_SCOPES[*]}"
    read -p "¿Continuar de todas formas? (s/n): " CONTINUE
    if [ "$CONTINUE" != "s" ] && [ "$CONTINUE" != "S" ]; then
      exit 1
    fi
  fi
  
  # Solicitar descripción (TEXTO LIBRE - el dev escribe lo que quiere)
  if [ -z "$DESCRIPTION" ]; then
    echo ""
    echo -e "${YELLOW}Descripción del commit:${NC}"
    echo -e "${BLUE}(Escribe tu propia descripción - será el mensaje del commit)${NC}"
    read -p "> " DESCRIPTION
  fi
fi

# Validar que tenemos todo
if [ -z "$TYPE" ] || [ -z "$SCOPE" ] || [ -z "$DESCRIPTION" ]; then
  echo -e "${RED}❌ Error: Faltan parámetros${NC}"
  echo ""
  echo "Uso: ./scripts/commit.sh [tipo] [scope] [descripción]"
  echo ""
  echo "Ejemplos:"
  echo "  ./scripts/commit.sh feat frontend \"agregar login con Google\""
  echo "  ./scripts/commit.sh fix backend \"corregir error 500 en API\""
  echo "  ./scripts/commit.sh  (modo interactivo)"
  exit 1
fi

# Validar que estamos en un repositorio git
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo -e "${RED}❌ Error: No estás en un repositorio git${NC}"
  exit 1
fi

# Validar que hay cambios para commitear
if git diff --staged --quiet && git diff --quiet; then
  echo -e "${RED}❌ Error: No hay cambios para commitear${NC}"
  echo "Agrega archivos con: git add ."
  exit 1
fi

# Construir mensaje de commit
COMMIT_MSG="${TYPE}(${SCOPE}): ${DESCRIPTION}"

# Mostrar preview
echo ""
echo -e "${GREEN}📋 Preview del commit:${NC}"
echo -e "${BLUE}${COMMIT_MSG}${NC}"
echo ""

# Confirmar
read -p "¿Crear commit? (s/n): " CONFIRM
if [ "$CONFIRM" != "s" ] && [ "$CONFIRM" != "S" ]; then
  echo -e "${YELLOW}❌ Cancelado${NC}"
  exit 0
fi

# Crear commit
git commit -m "$COMMIT_MSG"

echo ""
echo -e "${GREEN}✅ Commit creado exitosamente${NC}"
echo -e "${GREEN}📝 Mensaje: ${COMMIT_MSG}${NC}"

