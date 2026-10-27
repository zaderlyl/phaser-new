# phaser-new

Script shell qui génère la base d'un jeu Phaser 3 en JavaScript vanilla (sans Vite ni outil de build).

## Utilisation

```bash
./shell/phaser-new.sh mon-jeu
```

Le dossier `mon-jeu` est créé dans le répertoire courant. Le script refuse de continuer si ce dossier existe déjà. Il ne touche pas à git.

## Ce qui est généré

```
mon-jeu/
├── index.html          charge Phaser (CDN) et src/main.js
├── README.md
├── CLAUDE.md
├── .gitignore
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

Le jeu généré est une démo jouable : un menu, puis un carré déplaçable aux flèches (physique Arcade).

## Lancer le jeu généré

```bash
cd mon-jeu
npx serve
```

Puis ouvrir http://localhost:3000. Live Server (VS Code) fonctionne aussi.

## Installer la commande `phaser-new`

Ajouter un alias dans `~/.zshrc` :

```bash
echo "alias phaser-new='/Users/liliancornet/Documents/GitHub/phaser-new/shell/phaser-new.sh'" >> ~/.zshrc
```

Puis recharger le terminal :

```bash
source ~/.zshrc
```

Ensuite, depuis n'importe quel dossier :

```bash
phaser-new mon-jeu
```
