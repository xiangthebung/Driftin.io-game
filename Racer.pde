class Racer {
  PVector vel, acl, pos, prevPos;

  float orgAclSpeed, aclSpeed;

  String name, customUpgrade;

  float radius, health, maxHealth, healthRegen;

  float control, bounce, bodyDamage, cooldown, cooldownTimer;

  int duration;

  float angle;

  boolean shrunk = true;

  float spawnOffset;

  int mass;

  ArrayList<Racer> projectiles = new ArrayList<Racer>();


  Racer(float aclSpeed, float control, float r, String name, int mass, float bounce, float health, float healthRegen, float bodyDamage, float cooldown, int spawnOffset) {
    this.aclSpeed = aclSpeed;
    this.vel = new PVector(0, 0);
    this.acl = new PVector(0, 0);
    this.pos = new PVector(width/2, 300 + spawnOffset);
    this.radius = r;
    this.spawnOffset = spawnOffset;
    this.prevPos = new PVector(pos.x, pos.y);
    this.control =  1 - control;
    this.name = name;
    this.mass = mass;
    this.bounce = bounce;
    this.health = health;
    this.maxHealth = health;
    this.healthRegen = healthRegen;
    this.cooldownTimer = cooldown;
    this.bodyDamage = bodyDamage;
    if (this.name.equals("hazardRacer")) {
      this.customUpgrade = "Size upgrade";
    } else if (this.name.equals("circleRacer")) {
      this.customUpgrade = "Bounce Upgrade";
    } else if (this.name.equals("triangleRacer")) {
      this.customUpgrade = "Medkit heal";
    } else if (this.name.equals("flashRacer")) {
      this.customUpgrade = "Cooldown upgrade";
    } else if (this.name.equals("busterRacer")) {
      this.customUpgrade = "Cooldown upgrade";
    }
  }

  Racer(Racer r, int spawn) {

    this.aclSpeed = r.aclSpeed;
    this.vel = new PVector(0, 0);
    this.acl = new PVector(0, 0);
    this.pos = new PVector(width/2, 300 + spawn);
    this.radius = r.radius;
    this.spawnOffset = spawn;
    this.prevPos = new PVector(pos.x, pos.y);
    this.control =  r.control;
    this.name = r.name;
    this.mass = r.mass;
    this.bounce = r.bounce;
    this.health = r.health;
    this.healthRegen = r.healthRegen;
    this.maxHealth = r.maxHealth;
    this.bodyDamage = r.bodyDamage;
    this.cooldownTimer = r.cooldownTimer;
    this.customUpgrade = r.customUpgrade;
  }
  Racer(Racer r, int spawn, int duration) {

    this.aclSpeed = r.aclSpeed;
    this.vel = new PVector(0, 0);
    this.acl = new PVector(0, 0);
    this.pos = new PVector(width/2, 300 + spawn);
    this.radius = r.radius;
    this.spawnOffset = spawn;
    this.prevPos = new PVector(pos.x, pos.y);
    this.control =  r.control;
    this.name = r.name;
    this.mass = r.mass;
    this.bounce = r.bounce;
    this.health = r.health;
    this.healthRegen = r.healthRegen;
    this.maxHealth = r.maxHealth;
    this.bodyDamage = r.bodyDamage;
    this.cooldownTimer = r.cooldownTimer;
    this.customUpgrade = r.customUpgrade;
    this.duration = duration;
  }

  void move() {
    this.prevPos.set(pos);
    this.vel.add(acl).mult(control);
    this.pos.add(vel);
    if (! (-3000 < this.pos.x && this.pos.x < 5000 &&
      -5000 < this.pos.y && this.pos.y < 2000)) {
      println("Don't try to exploit my game pls :ANGRY FACE:");
      this.pos.set(width/2, height/2 + spawnOffset);
    }
  }

  void display(PGraphics pg, Player pl) {
    pg.fill(255, 0, 0);
    pg.rect(width/4 - radius*2.0/3, height/2 - radius-8, 4.0/3*radius, 5, 5);
    pg.fill(0, 255, 0);
    pg.rect(width/4 - radius*2.0/3, height/2 - radius-8, 4.0/3*radius*health/maxHealth, 5, 5);
    pg.fill(180, 85, 40);
    pg.rect(width/4 - radius * 2.0/3, height/2 - radius - 16, 4.0/3*radius*(1-cooldown/cooldownTimer), 5, 5);
    pg.push();
    pg.translate(width / 4, height / 2);
    pg.rotate(this.angle);
    if (this.name.equals("hazardRacer")) {
      pg.image(hazardRacerImage, -radius, -radius, 2*radius, 2*radius);
    } else if (this.name.equals("triangleRacer")) {

      pg.image(triangleRacerImage, -this.radius, -this.radius, 2 * radius, 2*radius);
    } else if (this.name.equals("circleRacer")) {
      pg.image(circleRacerImage, -this.radius, -radius, 2*radius, 2*radius);
    } else if (this.name.equals("flashRacer")) {
      pg.image(flashRacerImage, -radius, -radius, 2*radius, 2*radius);
    } else if (this.name.equals("busterRacer")) {
      pg.image(busterRacerImage, -radius, -radius, 2*radius, 2*radius);
    }
    pg.pop();
    for (int i = 0; i < projectiles.size(); i++) {
      Racer p = projectiles.get(i);
      pg.push();
      pg.translate(-pl.cam.x + width/4, -pl.cam.y + height/2);
      pg.translate(p.pos.x, p.pos.y);
      p.move();
      p.collide(squareMap);
      pg.image(ballImage, -p.radius, -p.radius, 2*p.radius, 2*p.radius);
      pg.pop();
      p.duration--;
      if (p.duration <= 0) {
        projectiles.remove(i);
      }
    }

    if (this.health < this.maxHealth) {
      this.health += healthRegen;
    }
    if (cooldown > 0) {
      cooldown --;
      if (this.name.equals("circleRacer")) {
        if (cooldown <= 2.0 /3 * cooldownTimer && !shrunk) {
          this.radius *= 2.0/3;
          shrunk = true;
        }
      } else if (this.name.equals("triangleRacer")) {
        if (cooldown <= 2.0/3 * cooldownTimer && !shrunk) {
          this.radius *= 2;
          shrunk = true;
        }
      }
    }
  }

  void displayRelative(PGraphics pg) {
    pg.fill(255, 0, 0);
    pg.rect(pos.x - radius*2.0/3, pos.y - radius-8, 4.0/3*radius, 5, 5);
    pg.fill(0, 255, 0);
    pg.rect(pos.x - radius*2.0/3, pos.y - radius-8, 4.0/3*radius*health/maxHealth, 5, 5);
    pg.push();
    pg.translate(pos.x, pos.y );
    pg.rotate(this.angle);
    if (this.name.equals("hazardRacer")) {
      pg.image(hazardRacerImage, -radius, -radius, 2*radius, 2*radius);
    } else if (this.name.equals("triangleRacer")) {
      pg.image(triangleRacerImage, -this.radius, -this.radius, 2*this.radius, 2*this.radius);
    } else if (this.name.equals("circleRacer")) {
      pg.image(circleRacerImage, -radius, -radius, 2*radius, 2*radius);
    } else if (this.name.equals("flashRacer")) {
      pg.image(flashRacerImage, -radius, -radius, 2*radius, 2*radius);
    } else if (this.name.equals("busterRacer")) {
      pg.image(busterRacerImage, -radius, -radius, 2*radius, 2*radius);
    }
    pg.pop();


    for (Racer p : projectiles) {
      pg.push();
      pg.translate(p.pos.x, p.pos.y);
      pg.image(ballImage, -p.radius, -p.radius, 2*p.radius, 2*p.radius);
      pg.pop();
    }
  }

  void activateAbility() {
    if (cooldown <= 0) {
      cooldown = cooldownTimer;
      if (this.name.equals("flashRacer")) {
        this.vel.mult(0.1);
      } else if (this.name.equals("circleRacer")) {
        this.radius *= 1.5;
        shrunk = false;
      } else if (this.name.equals("hazardRacer")) {
        this.vel.add(cos(this.angle) * 200*aclSpeed, sin(this.angle)*200*aclSpeed);
      } else if (this.name.equals("triangleRacer")) {
        this.radius *= 1.0/2;
        shrunk = false;
      } else if (this.name.equals("busterRacer")) {
        // Racer(aclSpeed,control,r,name,mass,bounce,health,healthRegen, bodyDamage, cooldown, spawnOffset);
        projectiles.add(new Racer(ball, 0, 500));
        projectiles.get(projectiles.size()-1).pos.set(this.pos);
        projectiles.get(projectiles.size()-1).vel.set(cos(this.angle) * 20, sin(this.angle)*20);
      }
    }
  }

  void upgrade1() {
    this.maxHealth *= 1.15;
    this.health *= 1.15;
  }

  void upgrade2() {
    this.aclSpeed *=1.15;
  }

  void upgrade3() {
    this.healthRegen *=1.15;
  }

  void upgrade4() {
    if (this.name.equals("circleRacer")) {
      this.bounce *= 1.1;
    } else if (this.name.equals("hazardRacer")) {
      this.radius *= 1.08;
    } else if (this.name.equals("triangleRacer")) {
      this.health = maxHealth;
    } else if (this.name.equals("flashRacer")) {
      this.cooldownTimer *= 0.9;
      this.cooldown *= 0.9;
    } else if (this.name.equals("busterRacer")) {
      this.cooldownTimer *= 0.9;
      this.cooldown *= 0.9;
    }
  }

  void collide(Map m) {
    if (m.name.equals("squareMap")) {
      for (CollisionBox c : squareMap.walls) {
        c.collisionDetection(this);
      }
    }
  }
}
