#!/bin/bash

# Definir colores
ROJO=$(tput setaf 1)
VERDE=$(tput setaf 2)
AMARILLO=$(tput setaf 3)
AZUL=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
BLANCO=$(tput setaf 7)
RESET=$(tput sgr0)

echo "${VERDE}🚀 Configurando workspace...${RESET}"
echo ""

echo "${AZUL}Paso 1: Clonando repositorios...${RESET}"
# Verificar submodules
git submodule update --init --recursive
rm -rf Librezam retro-portfolio kimu-underground portfolio-terminal-dhardi GLAZE-WM-make-windows-pretty-main-dizzi

# Recuperar cada submódulo
git submodule update --init --recursive Librezam
git submodule update --init --recursive retro-portfolio
git submodule update --init --recursive GLAZE-WM-make-windows-pretty-main-dizzi
git submodule update --init --recursive kimu-underground
git submodule update --init --recursive portfolio-terminal-dhardi
git submodule update --init --recursive PCE-Agencia
git submodule update --init --recursive portafolio-eric-godtier
git submodule update --init --recursive jscamp
git submodule update --init --recursive dhardi.dev
git submodule update --init --recursive opencode-discord-rpc
git submodule update --init --recursive opencode.nvim
git submodule update --init --recursive neocursor.nvim

echo ""
echo "${AMARILLO}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo "${ROJO}Paso 2 [TEORÍA]: BORRAR PERMANENTEMENTE los submódulos...${RESET}"
echo "${AMARILLO}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo "${CYAN}Script completo para eliminarlos definitivamente:${RESET}"
echo "  ${MAGENTA}git submodule deinit -f Librezam${RESET}"
echo "  ${MAGENTA}git rm -f Librezam${RESET}"
echo "  ${MAGENTA}rm -rf .git/modules/Librezam${RESET}"
echo "  ${CYAN}Lo mismo con el resto...${RESET}"
echo ""

echo "${AMARILLO}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo "${ROJO}Paso 3 [TEORÍA]: Agregar un nuevo submodule...${RESET}"
echo "${AMARILLO}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo "  ${MAGENTA}git submodule add https://el-repo-en-cuestion${RESET}"
echo ""

echo "${AMARILLO}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo "${AZUL}Paso 4: Corrigiendo el branch main...${RESET}"
echo "${AMARILLO}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

cd ./Librezam/ && git checkout main
cd ../GLAZE-WM-make-windows-pretty-main-dizzi/ && git checkout main
cd ../retro-portfolio/ && git checkout main
cd ../kimu-underground/ && git checkout main
cd ../portfolio-terminal-dhardi/ && git checkout main
cd ../FCTicService.github.6c-Diego-05/ && git checkout main
cd ../REACT-Diego-Dizzi-Dashboard/ && git checkout main
cd ../Proyecto-App-MCSD/ && git checkout main
cd ../PCE-Agencia/ && git checkout main
cd ../proyeccion-astral/ && git checkout main
cd ../portafolio-eric-godtier/ && git checkout main
cd ../jscamp/ && git checkout main
cd ../dhardi.dev/ && git checkout main
cd ../opencode-discord-rpc/ && git checkout main
cd ../opencode.nvim/ && git checkout main
cd ../neocursor.nvim/ && git checkout main

# Volver a la raíz del workspace
cd "$(dirname "$0")"

echo ""
echo "${AMARILLO}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo "${CYAN}Compilando plugin opencode-discord-rpc...${RESET}"
echo "${AMARILLO}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

if [ -d "opencode-discord-rpc" ]; then
  cd opencode-discord-rpc
  npm install
  npm run build
  cd ..
fi

echo ""
echo "${AMARILLO}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo "${AZUL}Paso 5: Configurando repos independientes (ptd-talento)...${RESET}"
echo "${AMARILLO}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

# Volver a la raiz del workspace
cd "$(dirname "$0")"

# ptd-talento-back
if [ -d "ptd-talento-back/.git" ]; then
  cd ptd-talento-back
  git checkout dev
  git remote set-url origin https://github.com/Cincinnatus-Institute-of-Craftsmanship/ptd-talento-back.git
  git remote set-url dizzi1222 https://github.com/dizzi1222/ptd-talento-back.git 2>/dev/null ||
    git remote add dizzi1222 https://github.com/dizzi1222/ptd-talento-back.git
  cd "$OLDPWD"
else
  echo "${ROJO}⚠ ptd-talento-back no existe, clonando...${RESET}"
  git clone https://github.com/Cincinnatus-Institute-of-Craftsmanship/ptd-talento-back.git
  cd ptd-talento-back && git checkout dev
  git remote add dizzi1222 https://github.com/dizzi1222/ptd-talento-back.git
  cd ..
fi

# ptd-talento-front
if [ -d "ptd-talento-front/.git" ]; then
  cd ptd-talento-front
  git checkout dev
  git remote set-url origin https://github.com/Cincinnatus-Institute-of-Craftsmanship/ptd-talento-front.git
  git remote set-url dizzi1222 https://github.com/dizzi1222/ptd-talento-front.git 2>/dev/null ||
    git remote add dizzi1222 https://github.com/dizzi1222/ptd-talento-front.git
  cd "$OLDPWD"
else
  echo "${ROJO}⚠ ptd-talento-front no existe, clonando...${RESET}"
  git clone https://github.com/Cincinnatus-Institute-of-Craftsmanship/ptd-talento-front.git
  cd ptd-talento-front && git checkout dev
  git remote add dizzi1222 https://github.com/dizzi1222/ptd-talento-front.git
  cd ..
fi

echo ""
echo "${VERDE}✅ Workspace listo!${RESET}"
