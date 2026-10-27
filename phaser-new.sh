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

cat > "$NOM/index.html" <<EOF
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>$NOM</title>
  <style>
    body { margin: 0; background: #111; display: flex; justify-content: center; }
  </style>
</head>
<body>
  <script src="https://cdn.jsdelivr.net/npm/phaser@3/dist/phaser.min.js"></script>
  <script type="module" src="src/main.js"></script>
</body>
</html>
EOF

cat > "$NOM/src/config.js" <<'EOF'
export const LARGEUR = 800;
export const HAUTEUR = 600;
export const VITESSE_JOUEUR = 200;
EOF

cat > "$NOM/src/main.js" <<'EOF'
import { LARGEUR, HAUTEUR } from './config.js';

const config = {
  type: Phaser.AUTO,
  width: LARGEUR,
  height: HAUTEUR,
  backgroundColor: '#1d1d2b',
  physics: {
    default: 'arcade',
    arcade: { debug: false },
  },
  scene: [],
};

new Phaser.Game(config);
EOF

cat > "$NOM/.gitignore" <<'EOF'
.DS_Store
node_modules/
EOF

echo "Projet « $NOM » créé."
