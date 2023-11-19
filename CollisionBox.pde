class CollisionBox {

  float x1, y1, x2, y2;

  CollisionBox(float x1, float y1, float x2, float y2) {
    this.x1 = x1; 
    this.y1 = y1; 
    this.x2 = x2; 
    this.y2 = y2;
  }

  void collisionDetection(Racer r) {

    float x = r.pos.x; 
    float y = r.pos.y; 
    float prevX = r.prevPos.x; 
    float prevY = r.prevPos.y;
    float rad = r.radius;

    float closestX = closestValue(x, x1, x2); //Returns the closest value to x
    float closestY = closestValue(y, y1, y2);  

    if (
      ((x + rad > closestX && prevX + rad < closestX) ||
      (x - rad < closestX && prevX - rad > closestX)) &&
      (y1 - rad + 1 < y && y < y2 + rad - 1 || y1 + rad - 1 > y && y > y2 - rad + 1)
      )
    {
      r.health -= abs(r.vel.x);
      r.vel.x = 0;  
      r.pos.x = prevX;
    }

    if (
      ((y + rad > closestY && prevY + rad < closestY) ||
      (y - rad < closestY && prevY - rad > closestY)) &&
      (x1 + rad - 1 > x && x > x2 - rad + 1|| x1 - rad + 1 < x && x < x2 + rad - 1)
      )
    { 
      r.health -= abs(r.vel.y);
      r.vel.y = 0;
      r.pos.y = prevY;
    }
  }

  void display(PGraphics pg) {
    pg.fill(100, 90, 150);
    pg.rect(x1, y1, x2 - x1, y2 - y1);
  }
}
