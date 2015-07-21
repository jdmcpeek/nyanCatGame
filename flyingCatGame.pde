// TODO
// 1. background and character image imports
// 2. how will acceleration and movement work?
// 3. text imports

// IDEAS
// 1. choose different characters before starting the game (multiple character options)
// 

int circleX = width/2;
int circleY = height/2;
float speed = 0; // px for every new drawframe
float widthWindow;
float heightWindow;
AcceleratingObject object = new AcceleratingObject();





void setup() {
  size(1280, 720);
  widthWindow = (float) width;
  heightWindow = (float) height;
  frameRate(60);
}

class Character {
  int x = width/2;
  int y = height/2;
  float speed = 0;
  int characterWidth = width/10;
  int characterHeight = height/10; 
  File image = null;

  Character(File image) {
    this.image = image;
  }

  void accelerate() {
  }

  void grow() {
  }


  void splitIntoArmy() {
  }
}

class AcceleratingObject {
  float x = width/2;
  float y = height/2; 
  float speedX = 0;
  float speedY = 0; 
  int directionX = 1;
  int directionY = 1; 

  // whether or not a key is being pressed
  boolean left = false;
  boolean right = false;
  boolean up = false;
  boolean down = false;  

  float maxSpeed = 20;  // px/frame
  float accelerationRateX = this.calculateAccelerationRate(4f, 1280);
  float accelerationRateY = this.calculateAccelerationRate(3f, 720);
  float frictionX = accelerationRateX / 2;
  float frictionY = accelerationRateY / 2;
  

  // travelTime = time in seconds it takes to move across the screen 
  // distance = width or height
  float calculateAccelerationRate(float travelTime, float distance) {
    return ((float) (2 * distance)) / sq(travelTime * frameRate);
  }

  void drawObject() {
    fill(0);
    ellipse(x, y, 50, 50);
  }

  // main object method, calls all other updaters
  public void move() {
//    println(speedX + " " + speedY);
    // what if we never changed the X and Y values? We simply translated the coordinate plane they live on. That could very well be the most brilliant and significant thought I've thought all day.
    pushMatrix();
    // translate by the speed. Since we're translating the coordinate grid, speed essentially becomes a proxy for spatial coordinates. 
    translate(speedX, speedY);  
    this.drawObject();
    popMatrix();
    this.updateDirectionAndFriction();
    this.accelerate();
  }
  
  // not sure what I'm doing here... I'm confusing a bunch of moving parts. I need to find a universal way of doing things and stick to it. 
  private void accelerate() {  // or `updateSpeed`
//    println(up + " " + down + " " + right + " " + left);
//    println(accelerationRateX + " " + accelerationRateY);
    if (up) speedY -= accelerationRateY;
    if (down) speedY += accelerationRateY;
    if (right) speedX += accelerationRateX;
    if (left) speedX -= accelerationRateX; 
  }


  private void updateDirectionAndFriction() {
    if (speedX < 0.5 && speedX > -0.5) {
      directionX = 0;
    } else if (speedX >= 0.5) {
      directionX = 1;
    } else {
      directionX = -1;
    }
    if (speedY < 0.5 && speedY > -0.5) {
      directionY = 0;
    } else if (speedY >= 0.5) {
      directionY = 1;
    } else {
      directionY = -1;
    }
//    directionX = speedX > 0 ? 1 : -1;
//    directionY = speedY > 0 ? -1 : 1;  // y is flipped because the origin is at the top left.
    frictionX = (accelerationRateX/2) * -directionX;  // friction is opposite of direction
    frictionY = (accelerationRateY/2) * -directionY;  // friction is opposite of direction
//    if (!up && !down) speedY += frictionY;
//    if (!left && !right) speedX += frictionX;
    
//    speedX += frictionX;
//    speedY += frictionY;
  }
}




void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP && object.up == false) object.up = true;
    if (keyCode == DOWN && object.down == false) object.down = true; 
    if (keyCode == RIGHT && object.right == false) object.right = true; 
    if (keyCode == LEFT && object.left == false) object.left = true;
    speedUp = true;
  }
}
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP) object.up = false;
    if (keyCode == DOWN) object.down = false;
    if (keyCode == RIGHT) object.right = false;
    if (keyCode == LEFT) object.left = false;
    speedUp = false;
  }
}

boolean speedUp = true;




double travelTime = 4;
double distance = (double)width;

double calculateAccelerationRate(double t, double d) {
  return (double) d;
}


// how to slow the circle down to a stop? Instead of a sudden, abrupt stop?
void draw() {
  background(255);

 
  

  object.move();
  
  
  
}


