// TODO
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

AcceleratingObject object;


// whether or not a key is being pressed
boolean left = false;
boolean right = false;
boolean up = false;
boolean down = false;  

PImage img;

void setup() {
  size(1280, 720);
  object = new Character(width/2, height/2, width/10, width/10);
  img = loadImage("Nyancat.png"); 
  frameRate(60);
}




class Character extends AcceleratingObject {

  Character(int x, int y, int characterWidth, int characterHeight) {
    super(x, y, characterWidth, characterHeight);
  }
  
  void draw() {
    if (directionX < 0) {
      pushMatrix();
      scale(-1, 1);
      image(img, -location.x - size.x, location.y, 60 * 1.36, 60);
      popMatrix();
    } else {
      image(img, location.x, location.y, 60 * 1.36, 60);
    }
    
  }
  
  void shootLasers() {
    
    
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

  void draw() {
    fill(0);
    ellipse(location.x, location.y, 50, 50);
  }

  // main object method, calls all other updaters
  public void move() {
    velocity.limit(30);
    if (location.x + size.x/2 > width || location.x < 0 - size.x/2) velocity.x *= -1;
    if (location.y > height - size.y/3 || location.y < 0) velocity.y *= -1;
    location.add(velocity);
    this.draw();
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






void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP && up == false) up = true;
    if (keyCode == DOWN && down == false) down = true; 
    if (keyCode == RIGHT && right == false) right = true; 
    if (keyCode == LEFT && left == false) left = true;
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


// how to slow the circle down to a stop? Instead of a sudden, abrupt stop?
void draw() {
  background(255);
  object.move();  
}


