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
