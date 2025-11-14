#!/bin/bash

# Script para crear una nueva rama hotfix con formato: hotfix/equipo/nombre-hotfix
# Uso: ./scripts/new-hotfix.sh [frontend|backend|ux-ui] nombre-hotfix
# NOTA: Los hotfixes se crean desde main

set -e

TEAM=$1
HOTFIX_NAME=$2

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Modo interactivo si no se proporcionan todos los parámetros
if [ -z "$TEAM" ] || [ -z "$HOTFIX_NAME" ]; then
  echo -e "${BLUE}🔥 Crear nueva rama hotfix${NC}"
  echo ""
  echo -e "${YELLOW}⚠️  NOTA: Los hotfixes se crean desde main (producción)${NC}"
  echo ""
  
  # Solicitar equipo
  if [ -z "$TEAM" ]; then
    echo -e "${YELLOW}Equipos disponibles:${NC}"
    echo "  1) frontend"
    echo "  2) backend"
    echo "  3) ux-ui"
    echo ""
    read -p "Selecciona el equipo (1-3 o nombre): " TEAM_INPUT
    
    case "$TEAM_INPUT" in
      1|frontend) TEAM="frontend" ;;
      2|backend) TEAM="backend" ;;
      3|ux-ui) TEAM="ux-ui" ;;
      *) 
        if [ "$TEAM_INPUT" == "frontend" ] || [ "$TEAM_INPUT" == "backend" ] || [ "$TEAM_INPUT" == "ux-ui" ]; then
          TEAM="$TEAM_INPUT"
        else
          echo -e "${RED}❌ Opción inválida${NC}"
          exit 1
        fi
        ;;
    esac
  fi
  
  # Solicitar nombre del hotfix
  if [ -z "$HOTFIX_NAME" ]; then
    echo ""
    echo -e "${YELLOW}Nombre del hotfix:${NC}"
    echo -e "${BLUE}(Usa minúsculas y guiones, ej: security-patch)${NC}"
    read -p "> " HOTFIX_NAME
  fi
  
  # Validar que se proporcionó todo
  if [ -z "$TEAM" ] || [ -z "$HOTFIX_NAME" ]; then
    echo -e "${RED}❌ Error: Debes proporcionar el equipo y el nombre del hotfix${NC}"
    echo ""
    echo "Uso: ./scripts/new-hotfix.sh [frontend|backend|ux-ui] nombre-hotfix"
    exit 1
  fi
fi

# Validar que el equipo sea válido
if [ "$TEAM" != "frontend" ] && [ "$TEAM" != "backend" ] && [ "$TEAM" != "ux-ui" ]; then
  echo -e "${RED}❌ Error: Equipo inválido${NC}"
  echo "Equipos válidos: frontend, backend, ux-ui"
  exit 1
fi

# Crear nombre de rama con formato: hotfix/equipo/nombre-hotfix
BRANCH_NAME="hotfix/$TEAM/$HOTFIX_NAME"

# Verificar que estamos en un repositorio git
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo -e "${RED}❌ Error: No estás en un repositorio git${NC}"
  exit 1
fi

# Verificar que la rama main existe
if ! git show-ref --verify --quiet refs/heads/main; then
  echo -e "${YELLOW}⚠️  Advertencia: La rama 'main' no existe localmente${NC}"
  echo "Intentando obtenerla desde el remoto..."
  git fetch origin main:main 2>/dev/null || {
    echo -e "${RED}❌ Error: No se pudo obtener la rama 'main'${NC}"
    exit 1
  }
fi

# Verificar que no existe la rama
if git show-ref --verify --quiet refs/heads/$BRANCH_NAME; then
  echo -e "${RED}❌ Error: La rama '$BRANCH_NAME' ya existe${NC}"
  exit 1
fi

# Cambiar a main y actualizar
echo -e "${YELLOW}📦 Cambiando a main y actualizando...${NC}"
git checkout main
git pull origin main

# Crear nueva rama
echo -e "${YELLOW}🔥 Creando rama hotfix: $BRANCH_NAME${NC}"
git checkout -b $BRANCH_NAME

echo ""
echo -e "${GREEN}✅ Rama hotfix creada exitosamente: $BRANCH_NAME${NC}"
echo -e "${GREEN}📍 Estás ahora en la rama: $BRANCH_NAME${NC}"
echo ""
echo -e "${YELLOW}⚠️  IMPORTANTE:${NC}"
echo "  1. Corrige el problema urgente"
echo "  2. Haz commit de tus cambios"
echo "  3. Push: git push -u origin $BRANCH_NAME"
echo "  4. Crea Pull Requests hacia:"
echo "     - main (producción) - PRIORIDAD"
echo "     - staging (para mantener sincronizado)"
echo "     - dev-frontend o dev-backend (según corresponda)"

