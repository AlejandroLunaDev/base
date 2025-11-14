#!/bin/bash

# Script para crear una nueva rama refactor con formato: refactor/equipo/nombre-refactor
# Uso: ./scripts/new-refactor.sh [frontend|backend] nombre-refactor

set -e

TEAM=$1
REFACTOR_NAME=$2

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Modo interactivo si no se proporcionan todos los parámetros
if [ -z "$TEAM" ] || [ -z "$REFACTOR_NAME" ]; then
  echo -e "${BLUE}🔧 Crear nueva rama refactor${NC}"
  echo ""
  
  # Solicitar equipo
  if [ -z "$TEAM" ]; then
    echo -e "${YELLOW}Equipos disponibles:${NC}"
    echo "  1) frontend"
    echo "  2) backend"
    echo ""
    read -p "Selecciona el equipo (1-2 o nombre): " TEAM_INPUT
    
    case "$TEAM_INPUT" in
      1|frontend) TEAM="frontend" ;;
      2|backend) TEAM="backend" ;;
      *) 
        if [ "$TEAM_INPUT" == "frontend" ] || [ "$TEAM_INPUT" == "backend" ]; then
          TEAM="$TEAM_INPUT"
        else
          echo -e "${RED}❌ Opción inválida${NC}"
          exit 1
        fi
        ;;
    esac
  fi
  
  # Solicitar nombre del refactor
  if [ -z "$REFACTOR_NAME" ]; then
    echo ""
    echo -e "${YELLOW}Nombre del refactor:${NC}"
    echo -e "${BLUE}(Usa minúsculas y guiones, ej: component-structure)${NC}"
    read -p "> " REFACTOR_NAME
  fi
  
  # Validar que se proporcionó todo
  if [ -z "$TEAM" ] || [ -z "$REFACTOR_NAME" ]; then
    echo -e "${RED}❌ Error: Debes proporcionar el equipo y el nombre del refactor${NC}"
    echo ""
    echo "Uso: ./scripts/new-refactor.sh [frontend|backend] nombre-refactor"
    exit 1
  fi
fi

# Validar que el equipo sea válido
if [ "$TEAM" != "frontend" ] && [ "$TEAM" != "backend" ]; then
  echo -e "${RED}❌ Error: Equipo inválido${NC}"
  echo "Equipos válidos: frontend, backend"
  exit 1
fi

# Determinar la rama base según el equipo
if [ "$TEAM" == "frontend" ]; then
  BASE_BRANCH="dev-frontend"
elif [ "$TEAM" == "backend" ]; then
  BASE_BRANCH="dev-backend"
fi

# Crear nombre de rama con formato: refactor/equipo/nombre-refactor
BRANCH_NAME="refactor/$TEAM/$REFACTOR_NAME"

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
echo -e "${YELLOW}🔧 Creando rama refactor: $BRANCH_NAME${NC}"
git checkout -b $BRANCH_NAME

echo ""
echo -e "${GREEN}✅ Rama creada exitosamente: $BRANCH_NAME${NC}"
echo -e "${GREEN}📍 Estás ahora en la rama: $BRANCH_NAME${NC}"
echo ""
echo "Próximos pasos:"
echo "  1. Refactoriza el código (sin cambiar funcionalidad)"
echo "  2. Haz commit de tus cambios"
echo "  3. Push: git push -u origin $BRANCH_NAME"
echo "  4. Crea un Pull Request hacia $BASE_BRANCH"

