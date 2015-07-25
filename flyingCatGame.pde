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

PImage img;
PImage missile;

void setup() {
  size(1280, 720);
  nyanCat = new Character(width/2, height/2, width/10, width/10);
  img = loadImage("Nyancat.png"); 
  missile = loadImage("missile.png");
  frameRate(60);
}





class Character extends AcceleratingObject {
  
  // create a max heap that will pop off the oldest laser and delete it.
  // for practice, make this heap YOURSELF, BITCH@*%
//  Queue<LaserBeam> lasers = new PriorityQueue();

  // cute to use my implementation for now, but when we ship it it's gotta be either the Java priorityQueue or simply an ArrayList that we sort.
  // Actually, I should just do first-in-first-out approach, because the first laser I fire, given that they all have the same speed, will be the first one to exceed the window's bounds. 
  // So I should just pop from the end of a queue.
  LinkedList<Projectile> projectiles;  // store lasers in this guy
//  LaserBeam laser;

  Character(int x, int y, int characterWidth, int characterHeight) {
    super(x, y, characterWidth, characterHeight);
    projectiles = new LinkedList();
  }
  
//  @Override
  void drawThing() {
    System.out.println(projectiles.size());
    for (int i = 0; i < projectiles.size(); i++) {
      projectiles.get(i).fire();
      if (projectiles.get(i).location.x > 1500 || projectiles.get(i).location.x < -100) {
        projectiles.remove(i);
      }
    }
    
    
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
      case 'f': projectile = new LaserBeam(location.x, location.y, 50, d, 50, 10, new Color(255, 0, 0));
                break;
      case 'd': projectile = new Missile(location.x, location.y, 20, d, 100, 70);
                break;
    
    }
    
    projectiles.add(projectile);
     
    
    
   

    
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
    
    location.x += speed * direction;
    
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
Missile m = new Missile(1000, 500, 10, -1, 100, 30);
// how to slow the circle down to a stop? Instead of a sudden, abrupt stop?
void draw() {
  background(255);

  nyanCat.move();  
  
  m.fire();
  
  
}


