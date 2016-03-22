
Mover mover;


void settings() {
  size(800, 800, P3D); 
}

void setup() {
  mover = new Mover();
  noStroke(); 
}

void draw() {
  
  background(255); 
//  camera(width/2, height/2, 800, 250, 250, 0, 0, 1, 0); 
  ambientLight(120, 120, 120); 
  directionalLight(0, 0, 160, 1, 1, 0);
  directionalLight(160, 0, 0, -1, 0, 0);
  text("Rotation along X : " + degrees(angleX) + "   Rotation along Z" + degrees(angleZ) + "   Speed :" + speed, 30, 20); 
  
  translate(width/2, height/2, 0); 
  rotateX(angleX); 
  rotateZ(angleZ); 
  box(300, 10, 300); 
  
  
 
   translate(0, -radius - 5, 0);
   mover.update();
   mover.checkEdges();
   mover.display();
   
 
}

void mouseDragged() {
  float delta = (abs(mouseY - posY) - abs(mouseX - posX)); 
  if(delta > 0) {
    if(mouseY > posY && angleX <= PI/3) {
     angleX = max(angleX - speed * PI/36, -PI/3);

    }
    if(mouseY < posY && angleX >= -PI/3) {
     angleX = min(angleX + speed * PI/36, PI/3); 
    }
  } else {
    if(mouseX > posX && angleZ <= PI/3) {
      angleZ = min(angleZ + speed * PI/36, PI/3); 
    }
    if(mouseX < posX && angleZ >= -PI/3) {
      angleZ = max(angleZ - speed * PI/36, -PI/3); 
    }
  }
  
  posX = mouseX; 
  posY = mouseY; 
}

void mouseWheel(MouseEvent event){
  float e = event.getCount();
  if(e < 0){
     if(speed < 1.5) {
       speed = min(speed + 0.1, 1.5); 
     }
  }
  if(e > 0) {
     if(speed > 0.2011) {
       speed = max(speed - 0.1, 0.2);  
     }
  }
}