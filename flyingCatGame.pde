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


boolean left = false;
boolean right = false;
boolean up = false;
boolean down = false;  


void setup() {
  size(1280, 720);
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





void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP && up == false) up = true;
    if (keyCode == DOWN && down == false) down = true; 
    if (keyCode == RIGHT && right == false) right = true; 
    if (keyCode == LEFT && left == false) left = true;
    speedUp = true; 
  }
}
void keyReleased() {
  if (key == CODED) {
    if (keyCode == UP && speed == 0) up = false;
    if (keyCode == DOWN && speed == 0) down = false;
    if (keyCode == RIGHT && speed == 0) right = false;
    if (keyCode == LEFT && speed == 0) left = false;
    speedUp = false;
  }
}

boolean speedUp = true;

 
  
  



// how to slow the circle down to a stop? Instead of a sudden, abrupt stop?
void draw() {
  background(255);
  fill(0);
  println(circleX + " " + circleY);
  ellipse(circleX, circleY, 50, 50);
  if (up) circleY -= speed;
  if (down) circleY -= -speed;
  if (right) circleX += speed;
  if (left) circleX += -speed;
  
 
  
  if (speedUp) {
    if (speed <= 20) {
      speed += 0.1;
    }
  } else if (speed > 0) {
    speed -= 0.1;
    
  }

  



}



