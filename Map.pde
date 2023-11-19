class Map {
  String name;
  ArrayList <CollisionBox> walls = new ArrayList<CollisionBox>();

  Map(String mapName) {
    this.name = mapName;
  }

  void createMap() {
    if (this.name.equals("squareMap")) {
      //Center wall
      walls.add(new CollisionBox( - 1500 + width / 2, - 3000, 1500 + width / 2, 0));
      //Bottom wall
      walls.add(new CollisionBox(- 1500 - 800, 600, 1500 + width/2 +800, 800));
      //Right wall
      walls.add(new CollisionBox( width/2 + 1500 + 600, 600, width /2 + 1500 + 800, - 3000 - 600));
      //Top wall
      walls.add(new CollisionBox(width/2 + 1500 + 800, - 600 - 3000, - 1500 + width/2 - 800, - 800 - 3000));
      //Left wall
      walls.add(new CollisionBox(- 1500 + width / 2 - 600, - 600 - 3000, - 1500 + width / 2 - 800, 600));
    }
  }

  void display(PGraphics pg, Player p, Boundary b) {
    if (this.name.equals("squareMap")) {
      pg.push();
      pg.fill(255, 0, 0);
      pg.translate(-p.cam.x + width/4, -p.cam.y + height/2);
      b.display(pg);
      for (CollisionBox c : walls) {
        c.display(pg);
      }
      for (int i = 0; i < 1000; i++) {
        pg.fill(0, 255, 0);
        pg.circle(bruh[i].x, bruh[i].y, 5);
      }
      pg.pop();
    }
  }
}
