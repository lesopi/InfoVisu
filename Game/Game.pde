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
  ambientLight(120, 120, 120); 
  directionalLight(160, 160, 160, -1, 1, 0);
  directionalLight(0, 0, 0, 1, 0, 0);
  if (shiftMode) {
    /*in shift mode we want to add cylinders to the plate
     */
    translate(width/2, height/2, 0); 
    fill(255);
    box(boxXZ, boxXZ, boxY); 
    for (PVector o : obstacles) {
      fill(100);
      drawCylinder(o.x, o.y, 0, shiftMode);
    }
    drawCylinder(mouseX - width/2, mouseY - height/2, 0, shiftMode);
  } else {
    /*in this mode we want to drag the plate to move the ball
    */
    //camera(width/2, height/2, 800, 250, 250, 0, 0, 1, 0); 
    text("Rotation along X : " + degrees(angleX) + "   Rotation along Z" + degrees(angleZ) + "   Speed :" + speed, 30, 20); 

    //move the plate 
    translate(width/2, height/2, 0); 
    rotateX(angleX); 
    rotateZ(angleZ);
    fill(220);
    box(boxXZ, boxY, boxXZ);

    // draw cylinders on the plate
    for (PVector o : obstacles) {
      pushMatrix();
      fill(100);
      drawCylinder(o.x, 0, o.y, shiftMode);
      popMatrix();
    }

    translate(0, -radius - boxY/2, 0);
    mover.update();
    mover.checkEdges();
    mover.checkCylinderCollision();
    mover.display();
  }
}


//not active in shiftMode, used to move the plate
void mouseDragged() {
  if (!shiftMode) {
    float delta = (abs(mouseY - posY) - abs(mouseX - posX)); 
    if (delta > 0) {
      if (mouseY > posY && angleX <= PI/3) {
        angleX = max(angleX - speed * PI/36, -PI/3);
      }
      if (mouseY < posY && angleX >= -PI/3) {
        angleX = min(angleX + speed * PI/36, PI/3);
      }
    } else {
      if (mouseX > posX && angleZ <= PI/3) {
        angleZ = min(angleZ + speed * PI/36, PI/3);
      }
      if (mouseX < posX && angleZ >= -PI/3) {
        angleZ = max(angleZ - speed * PI/36, -PI/3);
      }
    }

    posX = mouseX; 
    posY = mouseY;
  }
}



//not active in shiftMode, used to change the speed of the plate rotation
void mouseWheel(MouseEvent event) {
  if (!shiftMode) {

    float e = event.getCount();
    if (e < 0) {
      if (speed < 1.5) {
        speed = min(speed + 0.1, 1.5);
      }
    }
    if (e > 0) {
      if (speed > 0.2011) {
        speed = max(speed - 0.1, 0.2);
      }
    }
  }
}

// switch the game in shiftMode
void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shiftMode = true;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shiftMode = false;
    }
  }
}

// place cylinders on the plate in shiftMode
void mousePressed() {
  if (shiftMode) {
    if ((abs(width/2 - mouseX) <=(boxXZ/2))&& (abs(height/2 - mouseY) <= (boxXZ/2))) {
      PVector pos = new PVector(mouseX - width/2, mouseY - height/2, 0);
      if (obstacles.isEmpty()) {
        obstacles.add(pos);
      } else {
        boolean ok = true;
        for (PVector o : obstacles) {
          if (pos.dist(o) < 2*cylinderBaseSize) {
            ok = false;
          }
        }
        if (ok) {
          obstacles.add(pos);
        }
      }
    }
  }
}