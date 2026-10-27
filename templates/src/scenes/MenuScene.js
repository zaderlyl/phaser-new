import { LARGEUR, HAUTEUR } from '../config.js';

export class MenuScene extends Phaser.Scene {
  constructor() {
    super('MenuScene');
  }

  create() {
    this.add.text(LARGEUR / 2, HAUTEUR / 2 - 40, '__NOM__', { fontSize: '48px', color: '#ffffff' }).setOrigin(0.5);
    this.add.text(LARGEUR / 2, HAUTEUR / 2 + 30, 'Appuie sur ESPACE pour jouer', { fontSize: '20px', color: '#aaaaaa' }).setOrigin(0.5);

    this.input.keyboard.once('keydown-SPACE', () => {
      this.scene.start('GameScene');
    });
  }
}
