# __NOM__

Jeu Phaser 3 en JavaScript, sans outil de build : il suffit d'un serveur local pour le lancer.

## Lancer le jeu

```bash
npx serve
```

Puis ouvrir http://localhost:3000.

Alternative : clic droit sur `index.html` dans VS Code, puis « Open with Live Server » (extension Live Server).

Un serveur local est obligatoire : ouvrir `index.html` directement dans le navigateur bloque les modules JS et le chargement des assets.

## Contrôles

- ESPACE : lancer la partie depuis le menu
- Flèches : déplacer le carré

## Structure

```
index.html          page qui charge Phaser (libs/) et src/main.js
libs/               Phaser (phaser.min.js)
src/
  main.js           configuration Phaser et liste des scènes
  config.js         constantes du jeu (taille, vitesse...)
  scenes/           une classe par scène (Boot, Preload, Menu, Game)
  entities/         objets du jeu (Player...)
  managers/         logique transversale (InputManager...)
assets/             sprites, audio, maps
```

## Premiers pas

**Changer la vitesse du joueur** : modifier `VITESSE_JOUEUR` dans `src/config.js`.

**Utiliser une vraie image pour le joueur** :
1. Mettre l'image dans `assets/sprites/` (par exemple `joueur.png`).
2. Dans `src/scenes/PreloadScene.js`, charger l'image avec `this.load.image('joueur', 'assets/sprites/joueur.png');` et supprimer le carré dessiné dans `create()`.

**Ajouter une scène** :
1. Créer `src/scenes/MaScene.js` sur le modèle de `MenuScene.js`.
2. L'importer dans `src/main.js` et l'ajouter à la liste `scene`.
3. La lancer avec `this.scene.start('MaScene')`.

Documentation de Phaser : https://phaser.io/learn
