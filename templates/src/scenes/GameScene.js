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
