PGraphics p;
Boundary finishLine;

/* 
 Objective:
 Run 20 laps around the track, either way is fine
 You will get 1 point for each lap. This can be used for upgrades
 You will also get 1 point for killing the opponent
 
 CONTROLS FOR PLAYERS
 On menu: 
 Player 1: Change racer class with A and D, press E to enter
 Player 2: Change racer class with left and right arrow keys, press / to enter
 Playing:
 Player 1: Steer with A and D, move forward with W, move backward with S
 : Upgrade max health with 1, upgrade speed with 2, upgrade regen with 3, upgrade custom upgrade with 4
 : Activate special ability with e
 Player 2: Steer with left and right arrow keys, move forward with up arrow, and move backward with down arrow
 : Upgrade max health with p, upgrade speed with [, upgrade regen with ], and upgrade custom upgrade with \
 : Activate special ability with /
 */

void setup() {
  size(displayWidth, displayHeight);

  p = createGraphics(width/2, height);

  textSize(50);
  stroke(100, 50, 150, 200);
  strokeWeight(30);

  //  Racer(aclSpeed,control,r,name,mass,bounce,health,healthRegen, bodyDamage, cooldown, spawnOffset)
  hazardRacer = new Racer(0.18, 0.007, 30, "hazardRacer", 20, 0.6, 30, 0.005, 5, 700, 0);
  triangleRacer = new Racer(0.2, 0.002, 25, "triangleRacer", 15, 0.8, 70, 0.02, 1, 800, 0);
  circleRacer = new Racer(0.1, 0.01, 35, "circleRacer", 50, 1, 150, 0.01, 0.3, 800, 0);
  flashRacer = new Racer(0.3, 0.001, 25, "flashRacer", 10, 0.5, 50, 0.02, 0.5, 800, 0);
  busterRacer = new Racer(0.23, 0.008, 28, "busterRacer", 60, 0.6, 60, 0.02, 0.5, 600, 0);  
  ball = new Racer(0, 0.02, 25, "ball", 40, 0.8, 20, 0, 2, 0, 0);


  racers = new Racer[5];

  finishLine = new Boundary(width/2 - 1, 0, 600);

  racers[0] = hazardRacer;
  racers[1] = triangleRacer;
  racers[2] = circleRacer;
  racers[3] = flashRacer;
  racers[4]= busterRacer;


  squareMap = new Map("squareMap");
  squareMap.createMap();


  player1 = new Player(87, 83, 65, 68, 69, 49, 50, 51, 52, circleRacer, -75);
  player2 = new Player(38, 40, 37, 39, 47, 80, 91, 93, 92, flashRacer, 75);

  triangleRacerImage = loadImage("triangleRacer.png");
  circleRacerImage = loadImage("bully.png");
  flashRacerImage = loadImage("flash.png");
  busterRacerImage = loadImage("buster.png");
  hazardRacerImage = loadImage("hazard.png");
  ballImage = loadImage("ball.png");


  for (int i = 0; i < 1000; i++) {
    bruh[i] = new PVector(random( -1500 - width / 2, 1500 + width * 3.0 / 2), random( -3000 - height, height));
  }
}

Racer triangleRacer, hazardRacer, flashRacer, circleRacer, ball, busterRacer;
Racer[] racers;
PImage triangleRacerImage, circleRacerImage, flashRacerImage, busterRacerImage, hazardRacerImage, ballImage;
Player player1, player2;
int collideTimeout = 0;
Map squareMap;
boolean boosting;
PVector cam;
PVector[] bruh = new PVector[1000];


void draw() {
  p.noStroke();
  p.beginDraw();
  p.textSize(100);
  p.textAlign(CENTER);
  if (player1.menu) {
    p.background(100, 50, 180);
    p.fill(255, 100, 255);
    p.text("DRIFTIN.IO", width/4, height/4);
    p.textSize(30);
    p.fill(180, 120, 255);
    p.text("Choose your class", width/4, height/4 + 100);
    p.text(player1.racer.name, width/4, height/4 + 150);
  } else {
    p.background(200);
    finishLine.checkPassing(player1);
    squareMap.display(p, player1, finishLine);

    player1.displayRacer(p, player2);
    if (!player2.menu) {
      player1.displayOtherRacers(p, player2);
      for (Racer p : player2.racer.projectiles) {
        player1.collisionBalls(p, player2);
      }
    }
    p.textSize(20);
    p.fill(0, 50, 255);
    p.text("Points: " + str(player1.upgradePoints), width/2 - 70, 30);
    p.text("Laps completed:" + str(player1.laps), width/2 - 100, 60);
    p.textSize(15);
    p.fill(60, 50, 60);


    p.text("Max Health upgrade '1': " + str(player1.counter[1]), 100, height-200);
    p.text("Speed upgrade '2': " + str(player1.counter[2]), 100, height -150);
    p.text("Regen upgrade '3': " + str(player1.counter[3]), 100, height-100);
    p.text(player1.racer.customUpgrade + " '4': " + str(player1.counter[4]), 100, height-50);
  }
  p.endDraw();
  image(p, 0, 0);
  p.beginDraw();
  if (player2.menu) {
    p.background(100, 50, 180);
    p.fill(255, 100, 255);
    p.textSize(100);
    p.text("DRIFTIN.IO", width/4, height/4);
    p.textSize(30);
    p.fill(180, 120, 255);
    p.text("Choose your class", width/4, height/4 + 100);
    p.text(player2.racer.name, width/4, height/4 + 150);
  } else {
    p.background(200);
    finishLine.checkPassing(player2);
    if (!player1.menu) {

      player2.displayOtherRacers(p, player1);
    }
    squareMap.display(p, player2, finishLine);
    player2.displayRacer(p,player1);
    p.textSize(20);
    p.fill(0, 50, 255);
    p.text("Points: " + str(player2.upgradePoints), width/2 - 70, 30);
    p.text("Laps completed:" + str(player2.laps), width/2 - 100, 60);
    p.textSize(15);
    p.fill(60, 50, 60);


    p.text("Max Health upgrade 'P': " + str(player2.counter[1]), 100, height-200);
    p.text("Speed upgrade '[': " + str(player2.counter[2]), 100, height -150);
    p.text("Regen upgrade ']': " + str(player2.counter[3]), 100, height-100);
    p.text(player2.racer.customUpgrade + " '\\': " + str(player2.counter[4]), 100, height-50);
  }
  p.endDraw();
  image(p, width/2, 0);
  line(width/2, 0, width/2, height);
  if (!player1.menu && !player2.menu) {
    player1.collisionPlayers(player2);
    for (Racer p : player1.racer.projectiles) {
      player2.collisionBalls(p, player1);
    }
  }

}



float closestValue(float x1, float x2, float x3) {
  if (abs(x1 - x2) > abs(x1 - x3)) {
    return x3;
  } else {
    return x2;
  }
}


void keyPressed() {
  player1.moveRacer(keyCode);
  player2.moveRacer(keyCode);
}

void keyReleased() {
  player1.releaseKey(keyCode);
  player2.releaseKey(keyCode);
}

int findIndex(Player p, Racer[] r) {
  Racer ra = p.racer;
  for (int i = 0; i < r.length; i++) {
    if (ra.name.equals(r[i].name)) {
      return i;
    }
  }
  return -1;
}
