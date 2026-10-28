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
