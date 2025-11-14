#!/bin/bash

# Script para crear una nueva rama bugfix con formato: bugfix/equipo/nombre-bugfix
# Uso: ./scripts/new-bugfix.sh [frontend|backend|ux-ui] nombre-bugfix

set -e

TEAM=$1
BUGFIX_NAME=$2

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Validar argumentos
if [ -z "$TEAM" ] || [ -z "$BUGFIX_NAME" ]; then
  echo -e "${RED}❌ Error: Debes proporcionar el equipo y el nombre del bugfix${NC}"
  echo ""
  echo "Uso: ./scripts/new-bugfix.sh [frontend|backend|ux-ui] nombre-bugfix"
  echo ""
  echo "Ejemplos:"
  echo "  ./scripts/new-bugfix.sh frontend login-error-500"
  echo "  ./scripts/new-bugfix.sh backend api-timeout"
  echo "  ./scripts/new-bugfix.sh ux-ui mobile-menu-overlap"
  exit 1
fi

# Validar que el equipo sea válido
if [ "$TEAM" != "frontend" ] && [ "$TEAM" != "backend" ] && [ "$TEAM" != "ux-ui" ]; then
  echo -e "${RED}❌ Error: Equipo inválido${NC}"
  echo "Equipos válidos: frontend, backend, ux-ui"
  exit 1
fi

# Determinar la rama base según el equipo
if [ "$TEAM" == "frontend" ] || [ "$TEAM" == "ux-ui" ]; then
  BASE_BRANCH="dev-frontend"
elif [ "$TEAM" == "backend" ]; then
  BASE_BRANCH="dev-backend"
fi

# Crear nombre de rama con formato: bugfix/equipo/nombre-bugfix
BRANCH_NAME="bugfix/$TEAM/$BUGFIX_NAME"

# Verificar que estamos en un repositorio git
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo -e "${RED}❌ Error: No estás en un repositorio git${NC}"
  exit 1
fi

# Verificar que la rama base existe
if ! git show-ref --verify --quiet refs/heads/$BASE_BRANCH; then
  echo -e "${YELLOW}⚠️  Advertencia: La rama '$BASE_BRANCH' no existe localmente${NC}"
  echo "Intentando obtenerla desde el remoto..."
  git fetch origin $BASE_BRANCH:$BASE_BRANCH 2>/dev/null || {
    echo -e "${RED}❌ Error: No se pudo obtener la rama '$BASE_BRANCH'${NC}"
    exit 1
  }
fi

# Verificar que no existe la rama
if git show-ref --verify --quiet refs/heads/$BRANCH_NAME; then
  echo -e "${RED}❌ Error: La rama '$BRANCH_NAME' ya existe${NC}"
  exit 1
fi

# Cambiar a la rama base y actualizar
echo -e "${YELLOW}📦 Cambiando a $BASE_BRANCH y actualizando...${NC}"
git checkout $BASE_BRANCH
git pull origin $BASE_BRANCH

# Crear nueva rama
echo -e "${YELLOW}🐛 Creando rama bugfix: $BRANCH_NAME${NC}"
git checkout -b $BRANCH_NAME

echo ""
echo -e "${GREEN}✅ Rama creada exitosamente: $BRANCH_NAME${NC}"
echo -e "${GREEN}📍 Estás ahora en la rama: $BRANCH_NAME${NC}"
echo ""
echo "Próximos pasos:"
echo "  1. Corrige el bug"
echo "  2. Haz commit de tus cambios"
echo "  3. Push: git push -u origin $BRANCH_NAME"
echo "  4. Crea un Pull Request hacia $BASE_BRANCH"

