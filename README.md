# create-phaser-base

Génère en une commande la base d'un jeu Phaser 3 en JavaScript, sans Vite ni outil de build. Il suffit d'avoir [Node.js](https://nodejs.org) (version 18 ou plus).

## Créer un jeu

```bash
npm create phaser-base@latest mon-jeu
```

Sans nom, la commande le demande. Le nom ne peut contenir que des lettres, des chiffres, `-` et `_`.

Puis :

```bash
cd mon-jeu
npx serve
```

Et ouvrir http://localhost:3000.

## Ce qui est généré

```
mon-jeu/
├── index.html          charge Phaser (libs/) et src/main.js
├── README.md
├── .gitignore
├── libs/
│   └── phaser.min.js   Phaser 3.90.0, le jeu marche hors ligne
├── assets/
│   ├── sprites/
│   ├── audio/
│   └── maps/
└── src/
    ├── main.js         configuration Phaser et liste des scènes
    ├── config.js       constantes du jeu
    ├── scenes/         BootScene, PreloadScene, MenuScene, GameScene
    ├── entities/       Player.js
    └── managers/       InputManager.js
```

Le jeu généré est une démo jouable : un menu, puis un carré déplaçable aux flèches (physique Arcade). Son propre `README.md` explique comment le modifier.

## Version shell

L'ancienne version, un script bash qui ne marche que sur Mac et Linux, est conservée dans `shell/phaser-new.sh`.

```bash
./shell/phaser-new.sh mon-jeu
```

Différences avec la version npm : Phaser est chargé par CDN (internet obligatoire), le nom du jeu n'apparaît pas dans le menu, et un `CLAUDE.md` est généré.

Pour l'utiliser partout sur sa machine, ajouter un alias dans `~/.zshrc` :

```bash
echo "alias phaser-new='/Users/liliancornet/Documents/GitHub/phaser-new/shell/phaser-new.sh'" >> ~/.zshrc
```

```bash
source ~/.zshrc
```

## Développement

Tester le générateur sans le publier :

```bash
node bin/index.js mon-jeu-test
```

Le modèle du jeu est dans `templates/`, en vrais fichiers. `__NOM__` y est remplacé par le nom du jeu. Le fichier `_gitignore` est renommé en `.gitignore` à la génération (npm supprime les `.gitignore` à la publication).

Changer la version de Phaser : remplacer `templates/libs/phaser.min.js`, puis augmenter la version dans `package.json` avant de republier.
