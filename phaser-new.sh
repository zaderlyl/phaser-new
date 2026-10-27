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
import { BootScene } from './scenes/BootScene.js';
import { PreloadScene } from './scenes/PreloadScene.js';
import { MenuScene } from './scenes/MenuScene.js';
import { GameScene } from './scenes/GameScene.js';

const config = {
  type: Phaser.AUTO,
  width: LARGEUR,
  height: HAUTEUR,
  backgroundColor: '#1d1d2b',
  physics: {
    default: 'arcade',
    arcade: { debug: false },
  },
  scene: [BootScene, PreloadScene, MenuScene, GameScene],
};

new Phaser.Game(config);
EOF

cat > "$NOM/src/scenes/BootScene.js" <<'EOF'
export class BootScene extends Phaser.Scene {
  constructor() {
    super('BootScene');
  }

  create() {
    this.scene.start('PreloadScene');
  }
}
EOF

cat > "$NOM/src/scenes/PreloadScene.js" <<'EOF'
import { LARGEUR, HAUTEUR } from '../config.js';

export class PreloadScene extends Phaser.Scene {
  constructor() {
    super('PreloadScene');
  }

  preload() {
    const barre = this.add.rectangle(LARGEUR / 2 - 150, HAUTEUR / 2, 0, 20, 0xffffff).setOrigin(0, 0.5);
    this.load.on('progress', (valeur) => {
      barre.width = 300 * valeur;
    });

    // Charger les assets ici, par exemple :
    // this.load.image('joueur', 'assets/sprites/joueur.png');
  }

  create() {
    // Carré dessiné par Phaser, à remplacer par un vrai sprite
    const dessin = this.add.graphics();
    dessin.fillStyle(0x4fc3f7, 1);
    dessin.fillRect(0, 0, 32, 32);
    dessin.generateTexture('joueur', 32, 32);
    dessin.destroy();

    this.scene.start('MenuScene');
  }
}
EOF

cat > "$NOM/src/scenes/MenuScene.js" <<'EOF'
import { LARGEUR, HAUTEUR } from '../config.js';

export class MenuScene extends Phaser.Scene {
  constructor() {
    super('MenuScene');
  }

  create() {
    this.add.text(LARGEUR / 2, HAUTEUR / 2 - 40, 'Mon jeu', { fontSize: '48px', color: '#ffffff' }).setOrigin(0.5);
    this.add.text(LARGEUR / 2, HAUTEUR / 2 + 30, 'Appuie sur ESPACE pour jouer', { fontSize: '20px', color: '#aaaaaa' }).setOrigin(0.5);

    this.input.keyboard.once('keydown-SPACE', () => {
      this.scene.start('GameScene');
    });
  }
}
EOF

cat > "$NOM/src/scenes/GameScene.js" <<'EOF'
import { LARGEUR, HAUTEUR } from '../config.js';
import { Player } from '../entities/Player.js';
import { InputManager } from '../managers/InputManager.js';

export class GameScene extends Phaser.Scene {
  constructor() {
    super('GameScene');
  }

  create() {
    this.inputManager = new InputManager(this);
    this.player = new Player(this, LARGEUR / 2, HAUTEUR / 2);
  }

  update() {
    this.player.deplacer(this.inputManager.getDirection());
  }
}
EOF

cat > "$NOM/src/entities/Player.js" <<'EOF'
import { VITESSE_JOUEUR } from '../config.js';

export class Player extends Phaser.Physics.Arcade.Sprite {
  constructor(scene, x, y) {
    super(scene, x, y, 'joueur');
    scene.add.existing(this);
    scene.physics.add.existing(this);
    this.setCollideWorldBounds(true);
  }

  deplacer(direction) {
    this.setVelocity(direction.x * VITESSE_JOUEUR, direction.y * VITESSE_JOUEUR);

    // Évite d'aller plus vite en diagonale
    if (direction.x !== 0 && direction.y !== 0) {
      this.body.velocity.normalize().scale(VITESSE_JOUEUR);
    }
  }
}
EOF

cat > "$NOM/src/managers/InputManager.js" <<'EOF'
export class InputManager {
  constructor(scene) {
    this.touches = scene.input.keyboard.createCursorKeys();
  }

  // Renvoie -1, 0 ou 1 sur chaque axe
  getDirection() {
    return {
      x: Number(this.touches.right.isDown) - Number(this.touches.left.isDown),
      y: Number(this.touches.down.isDown) - Number(this.touches.up.isDown),
    };
  }
}
EOF

cat > "$NOM/.gitignore" <<'EOF'
.DS_Store
node_modules/
EOF

sed "s/__NOM__/$NOM/g" > "$NOM/README.md" <<'EOF'
# __NOM__

Jeu Phaser 3 en JavaScript vanilla (sans outil de build).

## Lancer le jeu

```bash
npx serve
```

Puis ouvrir http://localhost:3000.

Alternative : clic droit sur `index.html` dans VS Code, puis « Open with Live Server » (extension Live Server).

Un serveur local est obligatoire : ouvrir `index.html` directement dans le navigateur bloque les modules JS et le chargement des assets.

## Structure

```
index.html          page qui charge Phaser (CDN) et src/main.js
src/
  main.js           configuration Phaser et liste des scènes
  config.js         constantes du jeu (taille, vitesse...)
  scenes/           une classe par scène (Boot, Preload, Menu, Game)
  entities/         objets du jeu (Player...)
  managers/         logique transversale (InputManager...)
assets/             sprites, audio, maps
```

## Ajouter une scène

1. Créer `src/scenes/MaScene.js` sur le modèle de `MenuScene.js`.
2. L'importer dans `src/main.js` et l'ajouter à la liste `scene`.
3. La lancer avec `this.scene.start('MaScene')`.
EOF

sed "s/__NOM__/$NOM/g" > "$NOM/CLAUDE.md" <<'EOF'
# __NOM__

Jeu Phaser 3 en JavaScript vanilla, sans outil de build.

## Lancer le projet
```bash
npx serve
```
URL : http://localhost:3000

## Structure
```
index.html  charge Phaser (CDN) et src/main.js
src/        code source (scenes/, entities/, managers/, config.js, main.js)
assets/     sprites, audio, maps
README.md
```

## Conventions
- Une classe par fichier, nom du fichier = nom de la classe (PascalCase), commentaires en français.
- Constantes du jeu dans src/config.js.
- Chaque scène est enregistrée dans src/main.js.
- Garder cette même organisation sur tous mes projets.
EOF

echo "Projet « $NOM » créé."
