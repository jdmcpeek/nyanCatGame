// TODO
// 4. add clouds/scenery
// 5. other characters? 
// (done) 1. background and character image imports
// (done) 2. how will acceleration and movement work?
// 3. text imports

// IDEAS
// 1. choose different characters before starting the game (multiple character options)
// 2. add trail behind the character, like the Nyan cat's rainbow
// 3. add laser beam functionality ;)
// 

// maybe someday I'm going to have to create a Game object. But not yet... not yet. https://www.youtube.com/watch?v=OFVk5xVK7vs


int circleX = width/2;
int circleY = height/2;

Character nyanCat;

MaxHeap heap;
import java.util.Comparator;
import java.util.LinkedList; 
import java.util.ListIterator;
import java.util.Iterator;



// whether or not a key is being pressed
boolean left = false;
boolean right = false;
boolean up = false;
boolean down = false;  

Environment game;

PImage img;
PImage missile;

void setup() {
  size(1280, 720);
  game = new Environment(); 
  nyanCat = new Character(width/2, height/2, width/10, width/10);
  img = loadImage("Nyancat.png"); 
  missile = loadImage("missile.png");
  frameRate(60);
}


class Environment {
  LinkedList<Explosion> explosions = new LinkedList();
  LinkedList<Projectile> projectiles = new LinkedList();
  
  void drawEverything() {
    drawProjectiles();
    drawExplosions();
  }



  void drawProjectiles() {
    int numberOfBogies = projectiles.size();
    //    System.out.println(numberOfBogies);
    for (int i = 0; i < projectiles.size (); i++) {
      projectiles.get(i).fire();
      if (projectiles.get(i).location.x > width + 100 || projectiles.get(i).location.x < -100) {
        projectiles.remove(i);
      }
    }
  }

  void drawExplosions() {
    int numberOfBogies = explosions.size();
    System.out.println(numberOfBogies);
    for (int i = 0; i < explosions.size (); i++) {
      explosions.get(i).explode();
      if (explosions.get(i).dissipate) { // explosion explodes, then shrinks to nothingness
        explosions.remove(i);
      }
    }
  }
}





class Character extends AcceleratingObject {


  LinkedList<Projectile> projectiles;  // store lasers in this guy

  Character(int x, int y, int characterWidth, int characterHeight) {
    super(x, y, characterWidth, characterHeight);
    projectiles = new LinkedList();
  }

  //  @Override
  void drawThing() {

    if (left) {
      pushMatrix();
      scale(-1, 1);
      image(img, -location.x - size.x, location.y, 60 * 1.36, 60);
      popMatrix();
    } else if (right) {
      image(img, location.x, location.y, 60 * 1.36, 60);
    } else if (directionX < 0) {
      pushMatrix();
      scale(-1, 1);
      image(img, -location.x - size.x, location.y, 60 * 1.36, 60);
      popMatrix();
    } else {
      image(img, location.x, location.y, 60 * 1.36, 60);
    }
  }

  // need to add a `type` parameter
  void shootLasers(char k) {
    // create new laser.
    // store each new laser in a max heap.
    // PVector origin, int speed, int direction, PVector dimensions, Color rgb
    int d = directionX;
    if (left) d = -1;
    if (right) d = 1;

    Projectile projectile = new Projectile(location.x, location.y, 50, d, 50, 10);

    switch (key) {
      case 'f': 
        projectile = new LaserBeam(location.x, location.y, 50, d, 50, 10, new Color(255, 0, 0));
        break;
      case 'd': 
        projectile = new Missile(location.x, location.y, 20, d, 100, 70);
        break;
      case 's':
        projectile = new Missile(location.x, location.y, 20, d, 100, 70);
        break;
    }

    game.projectiles.add(projectile);
  }

  void grow() {
  }


  void splitIntoArmy() {
  }
}

class AcceleratingObject {

  PVector location = new PVector(640, 360);
  PVector velocity = new PVector(0, 0);
  float maxSpeed = 20; 
  float accelerationRateX = this.calculateAccelerationRate(10f, 1280);
  float accelerationRateY = this.calculateAccelerationRate(8f, 720);
  float frictionX = accelerationRateX / 2;
  float frictionY = accelerationRateY / 2;
  PVector size = new PVector(0, 0);

  int directionX = 1;
  int directionY = 1; 

  AcceleratingObject(int x, int y, int sizeX, int sizeY) {
    location.x = x;
    location.y = y;
    size.x = sizeX;
    size.y = sizeY;
  }


  // travelTime = time in seconds it takes to move across the screen 
  // distance = width or height
  float calculateAccelerationRate(float travelTime, float distance) {
    return ((float) (2 * distance)) / sq(travelTime * frameRate);
  }

  void drawThing() {
    fill(0);
    ellipse(location.x, location.y, 50, 50);
  }

  // main object method, calls all other updaters
  public void move() {
    velocity.limit(30);
    if (location.x + size.x/2 > width || location.x < 0 - size.x/2) velocity.x *= -1;
    if (location.y > height - size.y/3 || location.y < 0) velocity.y *= -1;
    location.add(velocity);
    this.drawThing();
    this.accelerate();

    directionX = velocity.x > 0 ? 1 : -1;
  }

  // not sure what I'm doing here... I'm confusing a bunch of moving parts. I need to find a universal way of doing things and stick to it. 
  private void accelerate() {  // or `updateSpeed`
    if (up) velocity.y -= accelerationRateY;
    if (down) velocity.y += accelerationRateY;
    if (right) velocity.x += accelerationRateX;
    if (left) velocity.x -= accelerationRateX;
  }
}

class Explosion {
  PVector location;
  PImage image;
  float maxRadius;
  float radius = 1;
  Color rgb;
  boolean dissipate = false;
  boolean expand = true;


  Explosion(float x, float y, float maxRadius) {
    this(x, y, maxRadius, new Color());
  }
  
  Explosion(float x, float y, float maxRadius, Color rgb) {
    location = new PVector(x, y);
    this.maxRadius = maxRadius; 
    this.rgb = rgb;
  }

  void explode() {

    rgb.fillColor();
    ellipse(location.x, location.y, radius, radius);
    fill(255, 215, 0);
    ellipse(location.x, location.y, radius/2, radius/2);
    if (radius > maxRadius) expand = false;  
    if (expand) radius++; else radius = radius - 2;
    if (radius < 1) dissipate = true;  // remove explosion
  }
}

// how am I going to emulate explosions? What should the object design be?
class Projectile {
  PVector location;
  int speed;  
  int direction;
  PVector dimensions;

  Projectile(float x, float y, int speed, int direction, int w, int h) {
    location = new PVector(x, y);
    this.speed = speed;
    this.direction = direction;
    dimensions = new PVector(w, h);
  }

  void fire() {
    fill(0);
    rect(location.x, location.y, dimensions.x, dimensions.y, 20);
    location.x += speed * direction;
    explode();
  }

  boolean impact() {
    if (location.x > width - 50 && location.x < width - 25) return true;
    else if (location.x < 50 && location.x > 25) return true;
    // loop through all game objects and enemies and check to see if the projectile coincides with that.
//    else if (random(0, 10) < 2) return true;
    else return false;
  }

  // we only want to create one new explosion (actually, the trail effect is really fucking cool. Psychedilic. Keep that shit in)
  void explode() {
    if (impact()) {
      Explosion explosion = new Explosion(location.x, location.y, 100);
      game.explosions.add(explosion);
    }
  }
}

class LaserBeam extends Projectile {

  Color rgb;


  LaserBeam(float x, float y, int speed, int direction, int w, int h, Color rgb) {
    super(x, y, speed, direction, w, h);
    this.rgb = rgb;
  }

  @Override
    void fire() {
    rgb.fillColor();
    rect(location.x, location.y, dimensions.x, dimensions.y, 20);
    location.x += speed * direction;
    explode();
  }
}

class Missile extends Projectile {

  Missile(float x, float y, int speed, int direction, int w, int h) {
    super(x, y, speed, direction, w, h);
  }

  @Override
  void fire() {
    if (direction > 0) {
      pushMatrix();
      scale(-1, 1);
      image(missile, -location.x - dimensions.x, location.y, 100, 75);
      popMatrix();
    } else if (direction < 0) {
      image(missile, location.x, location.y, 100, 75);
    }
    
    if (random(0, 10) < 5) {
      Explosion fireTrail = new Explosion(location.x, location.y + dimensions.y/2, 25, new Color(255, 0, 0)); 
      game.explosions.add(fireTrail);
    }

    location.x += speed * direction;
    explode();
  }
}


class Color {
  float red, green, blue;

  Color() {
    this(random(0, 255), random(0, 255), random(0, 255));
  }

  Color(float red, float green, float blue) {
    this.red = red;
    this.green = green;
    this.blue = blue;
  }

  void fillColor() {
    fill(red, green, blue);
  }

  void backgroundColor() {
    background(red, green, blue);
  }
}






void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP && up == false) up = true;
    if (keyCode == DOWN && down == false) down = true; 
    if (keyCode == RIGHT && right == false) right = true; 
    if (keyCode == LEFT && left == false) left = true;
  }

  if (key == 'f' || key == 'd' || key == 's' || key == 'a') {
    nyanCat.shootLasers(key);
  }
}
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) up = false;
    if (keyCode == DOWN) down = false;
    if (keyCode == RIGHT) right = false;
    if (keyCode == LEFT) left = false;
  }
}

//PVector origin, int speed, int direction, PVector dimensions
// how to slow the circle down to a stop? Instead of a sudden, abrupt stop?
void draw() {
  background(255);

  nyanCat.move();  
  game.drawEverything();
}

