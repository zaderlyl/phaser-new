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
