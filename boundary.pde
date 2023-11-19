class Boundary {
  PVector pos;
  float len;
  Boundary(float x, float y, float len) {
    pos = new PVector(x, y);
    this.len = len;
  }

  void display(PGraphics pg) {
    pg.fill(200, 180, 220, 220);
    pg.rect(pos.x - 20, pos.y, 40, pos.y + len);
  }

  void checkPassing(Player p) {
    PVector prevPos = new PVector(p.racer.prevPos.x, p.racer.prevPos.y);
    PVector posNow = new PVector(p.racer.pos.x, p.racer.pos.y);
    float y = p.racer.pos.y;

    if (this.pos.y < y && y < this.pos.y + this.len) {
      if (prevPos.x < this.pos.x && this.pos.x < posNow.x) {
        if (p.rightSide) {
          p.racer.health = p.racer.maxHealth;
          p.upgradePoints ++;
          p.laps ++;
        } else {
          p.leftSide = false;
          p.rightSide = true;
        }
      }
      if (prevPos.x > this.pos.x && this.pos.x > posNow.x) {
        if (p.leftSide) {
          p.racer.health = p.racer.maxHealth;
          p.upgradePoints ++;
          p.laps++;
        } else {
          p.rightSide = false;
          p.leftSide = true;
        }
      }
    }
  }
}
