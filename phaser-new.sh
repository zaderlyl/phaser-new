#!/usr/bin/env bash
# Génère la base d'un jeu Phaser (JS vanilla, sans outil de build).
# Usage : phaser-new.sh <nom-du-jeu>

set -euo pipefail

if [ $# -ne 1 ]; then
  echo "Usage : phaser-new <nom-du-jeu>" >&2
  exit 1
fi

NOM="$1"

if [ -e "$NOM" ]; then
  echo "Erreur : « $NOM » existe déjà." >&2
  exit 1
fi

mkdir -p "$NOM"/assets/{sprites,audio,maps}
mkdir -p "$NOM"/src/{scenes,entities,managers}

echo "Projet « $NOM » créé."
