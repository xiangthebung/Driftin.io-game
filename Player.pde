class Player {
  //Camera position
  PVector cam = new PVector(0, 0);

  //Player controls
  int forward, backward, turnLeft, turnRight, ability, up1, up2, up3, up4;
  int[] counter = new int[5];
  boolean turningLeft, turningRight, goingForward, goingBackward;
  //Player Racer
  Racer racer;
  int timer;



  int upgradePoints, laps;
  boolean rightSide = true, leftSide;

  boolean menu = true;

  int playerSpawn;

  int racerIndex;

  Player(int f, int b, int tL, int tR, int ability, int up1, int up2, int up3, int up4, Racer r, int spawn) {
    this.forward = f;
    this.backward = b;
    this.turnLeft = tL;
    this.turnRight = tR;
    this.ability = ability;
    this.playerSpawn = spawn;
    this.up1 = up1;
    this.up2 = up2;
    this.up3 = up3;
    this.up4 = up4;
    this.racer = new Racer(r, spawn);
    this.racerIndex = findIndex(this, racers);
  }

  void moveRacer(int m) {

    if (this.menu) {
      if ( m == turnLeft) {
        this.racer = new Racer(racers[( racerIndex + 1) % racers.length], playerSpawn);
        this.racerIndex = findIndex(this, racers);
      } else if (m == turnRight) {
        this.racer = new Racer(racers[(racers.length + racerIndex - 1) % racers.length], playerSpawn);
        this.racerIndex = findIndex(this, racers);
      } else if (m == ability) {
        this.menu = false;
      }
    } else {
      if (m == forward) {
        goingForward = true;
      }
      if (m == backward) {
        goingBackward = true;
      }
      if (m == turnLeft) {
        turningLeft = true;
      }
      if (m == turnRight) {   
        turningRight = true;
      }
      if (m == ability) {
        this.racer.activateAbility();
      }
      if (this.upgradePoints > 0) {
        if (m == up1 && counter[1] < 10) {
          this.racer.upgrade1();
          counter[1] ++;
          this.upgradePoints --;
        }
        if (m == up2 && counter[2] < 10) {
          this.racer.upgrade2();
          counter[2]++;
          this.upgradePoints --;
        }
        if (m == up3 && counter[3] < 10) {
          this.racer.upgrade3();
          counter[3]++;
          this.upgradePoints --;
        }
        if (m == up4 && counter[4] < 10) {
          this.racer.upgrade4();
          counter[4]++;
          this.upgradePoints --;
        }
      }
    }
  }

  void releaseKey(int m) {
    if (m == forward) {
      goingForward = false;
      racer.acl.set(0, 0);
    } 
    if (m == backward) {
      goingBackward = false;
      racer.acl.set(0, 0);
    }
    if (m == turnLeft) {
      turningLeft = false;
    }
    if (m == turnRight) {
      turningRight = false;
    }
  }
  void collisionPlayers(Player p) {
    float x1, y1, x2, y2, r1, r2;
    x1 = this.racer.pos.x; 
    x2 = p.racer.pos.x;
    y1 = this.racer.pos.y; 
    y2 = p.racer.pos.y;
    r1 = this.racer.radius;
    r2 = p.racer.radius;

    float d = dist(x1, y1, x2, y2);



    if (
      d < r1 + r2
      ) {
      PVector v1 = new PVector(this.racer.vel.x, this.racer.vel.y);
      PVector v2 = new PVector(p.racer.vel.x, p.racer.vel.y);
      float mass1 = this.racer.mass, mass2 = p.racer.mass;
      float n = r1 + r2 - d;
      float dx = x2 - x1;
      float dy = y2 - y1;
      float angle = atan2(dy, dx);
      float sin = sin(angle), cos = cos(angle);

      float vx1 = v1.x*cos + v1.y*sin;
      float vy1 = v1.y*cos - v1.x*sin;
      float vx2 = v2.x*cos + v2.y*sin;
      float vy2 = v2.y*cos - v2.y*sin;

      float ax1 = 0, ay1 = 0;
      float ax2 = dx * cos + dy * sin;
      float ay2 = dy*cos - dx * sin;

      float vx1final = ((mass1 - mass2) * vx1 + 2*  mass2*vx2)/(mass1 + mass2);
      float vx2final = ((mass2 - mass1) * vx2 + 2 * mass1*vx1)/(mass1 + mass2);

      vx1 = vx1final;
      vx2 = vx2final;

      float absV = abs(vx1) + abs(vx2);
      ax1 += vx1/absV * n;
      ax2 += vx2/absV * n;

      float x1final = ax1*cos ;
      float y1final = ax1 * sin;
      float x2final = ax2 * cos - ay2 *sin;
      float y2final = ay2 * cos + ax2 * sin;

      this.racer.pos.add(x1final, y1final);
      p.racer.pos.set(this.racer.pos.x + x2final, this.racer.pos.y + y2final);

      this.racer.vel.set(vx1*cos-vy1*sin, vy1*cos + vx1*sin).mult(p.racer.bounce);
      p.racer.vel.set(vx2*cos - vy2*sin, vy2*cos + vx2 * sin).mult(this.racer.bounce);


      this.racer.pos.add(this.racer.vel);
      p.racer.pos.add(p.racer.vel);

      this.racer.health -= n*p.racer.bodyDamage;
      p.racer.health -= n*this.racer.bodyDamage;

      this.timer = 120;
      p.timer = 120;
    }
  }

  void collisionBalls(Racer racer, Player p) {
    float x1, y1, x2, y2, r1, r2;
    x1 = this.racer.pos.x; 
    x2 = racer.pos.x;
    y1 = this.racer.pos.y; 
    y2 = racer.pos.y;
    r1 = this.racer.radius;
    r2 = racer.radius;

    float d = dist(x1, y1, x2, y2);



    if (
      d < r1 + r2
      ) {
      PVector v1 = new PVector(this.racer.vel.x, this.racer.vel.y);
      PVector v2 = new PVector(racer.vel.x, racer.vel.y);
      float mass1 = this.racer.mass, mass2 = racer.mass;
      float n = r1 + r2 - d;
      float dx = x2 - x1;
      float dy = y2 - y1;
      float angle = atan2(dy, dx);
      float sin = sin(angle), cos = cos(angle);

      float vx1 = v1.x*cos + v1.y*sin;
      float vy1 = v1.y*cos - v1.x*sin;
      float vx2 = v2.x*cos + v2.y*sin;
      float vy2 = v2.y*cos - v2.y*sin;

      float ax1 = 0, ay1 = 0;
      float ax2 = dx * cos + dy * sin;
      float ay2 = dy*cos - dx * sin;

      float vx1final = ((mass1 - mass2) * vx1 + 2*  mass2*vx2)/(mass1 + mass2);
      float vx2final = ((mass2 - mass1) * vx2 + 2 * mass1*vx1)/(mass1 + mass2);

      vx1 = vx1final;
      vx2 = vx2final;

      float absV = abs(vx1) + abs(vx2);
      ax1 += vx1/absV * n;
      ax2 += vx2/absV * n;

      float x1final = ax1*cos ;
      float y1final = ax1 * sin;
      float x2final = ax2 * cos - ay2 *sin;
      float y2final = ay2 * cos + ax2 * sin;

      this.racer.pos.add(x1final, y1final);
      racer.pos.set(this.racer.pos.x + x2final, this.racer.pos.y + y2final);

      this.racer.vel.set(vx1*cos-vy1*sin, vy1*cos + vx1*sin).mult(racer.bounce);
      racer.vel.set(vx2*cos - vy2*sin, vy2*cos + vx2 * sin).mult(this.racer.bounce);


      this.racer.pos.add(this.racer.vel);
      racer.pos.add(racer.vel);

      this.racer.health -= n*racer.bodyDamage;

      this.timer = 120;
    }
  }


  void displayRacer(PGraphics pg, Player p) {
    if (this.timer > 0) {
      timer--;
    }
    this.racer.collide(squareMap);
    if (turningRight) {
      racer.angle += 0.1;
    }
    if (turningLeft) {
      racer.angle -= 0.1;
    }
    if (goingForward) {
      racer.acl.set(cos(racer.angle), sin(racer.angle)).mult(racer.aclSpeed);
    }
    if (goingBackward) {
      racer.acl.set( - cos(racer.angle), -sin(racer.angle)).mult(racer.aclSpeed);
    }

    this.racer.move();
    this.racer.display(pg, this);
    this.cam.set(this.racer.pos);
    if (this.racer.health <= 0 && this.timer <= 120) {
      p.upgradePoints++;
    }
    if (p.racer.health <= 0 && p.timer <= 120) {
      this.upgradePoints++;
    }
    if (this.racer.health <= 0) {
      this.racer = new Racer(racers[racerIndex], this.playerSpawn);
      this.laps = 0;
      this.counter = new int[5];
      this.upgradePoints = 0;
      this.rightSide = true;
      this.leftSide = false;
      this.menu = true;
    }
    if (this.laps == 20) {
      pg.fill(255, 200, 222);
      pg.textSize(20);
      pg.text("You have won! Restart the program to play again", width/4, height/2);
    }
  }

  void displayOtherRacers(PGraphics pg, Player p) {
    pg.push();
    pg.translate( -this.cam.x + width / 4, -this.cam.y + height / 2);
    p.racer.displayRelative(pg);
    pg.pop();
  }
}
