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
