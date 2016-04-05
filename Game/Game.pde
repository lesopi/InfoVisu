Mover mover;
PGraphics bottomSurface;
PGraphics topView;


void settings() {
  size(800, 800, P3D);
}


void setup() {
  mover = new Mover();
  bottomSurface = createGraphics(800, bSH, P2D);
  topView = createGraphics(100, 100, P2D);

  noStroke();
}


void draw() {
  background(255);
  noLights();
  fill(255);
  drawBottomSurface();
  image(bottomSurface, 0, 800 - bSH);
  drawTopView();
  image(topView, 0, 800 - bSH);

  ambientLight(120, 120, 120); 
  directionalLight(160, 160, 160, -1, 1, 0);
  directionalLight(0, 0, 0, 1, 0, 0);



  if (shiftMode) {
    /*in shift mode we want to add cylinders to the plate
     */
    translate(width/2, height/2, 0); 
    fill(255);
    box(boxXZ, boxXZ, boxY); 
    for (PVector o : obst) {
      fill(100);
      drawCylinder(o.x, o.y, 0, shiftMode);
    }
    fill(100);
    drawCylinder(mouseX - width/2, mouseY - height/2, 0, shiftMode);
  } else {
    /*in this mode we want to drag the plate to move the ball
     */
    //camera(width/2, height/2, 1000, width/2, height/2, 0, 0, 1, 0); 
    text("Rotation along X : " + degrees(angleX) + "   Rotation along Z" + degrees(angleZ) + "   Speed :" + speed, 30, 20); 
    //move the plate 
    translate(width/2, height/2, 0); 
    rotateX(angleX); 
    rotateZ(angleZ);
    fill(220);
    box(boxXZ, boxY, boxXZ);

    // draw cylinders on the plate
    for (PVector o : obst) {
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

/* place cylinders on the plate in shiftMode
* idea: we divide the plate in 4 subplates: nw, sw, ne, se, and add the cylinder to the corresponding subplate
* if there is a cylinder over 2 or 4 subplates, add it in all the corresponding subplates
* the arraylist obst contains all the cylinders, we use it to draw faster
*
* remark: The complexity of this method is not the best, but we don't need to be fast in Shift mode
*/
void mousePressed() {
  if (shiftMode) {
    if ((abs(width/2 - mouseX) <=(boxXZ/2))&& (abs(height/2 - mouseY) <= (boxXZ/2))) {
      PVector pos = new PVector(mouseX - width/2, mouseY - height/2, 0);
      addCylinder(pos);
      addif(obst, pos);
    }
  }
}

// find the corresponding subplate
void addCylinder(PVector pos) {
  int zone = 0;
  if (abs(pos.x - width/2) <= cylinderBaseSize) {
    zone += 2;
  } else if (pos.x < width/2) {
    zone += 1;
  } else {
    zone += 3;
  }
  if (abs(pos.y - height/2) <= cylinderBaseSize) {
    zone += 20;
  } else if (pos.y < height/2) {
    zone += 10;
  } else {
    zone += 30;
  }

  switch(zone) {
  case 11: 
    addif(nw, pos);
    break;
  case 12: 
    addif(nw, pos);
    addif(ne, pos);
    break;
  case 13: 
    addif(se, pos);
    break;
  case 21: 
    addif(nw, pos);
    addif(sw, pos);
    break;
  case 22: 
    addif(nw, pos);
    addif(ne, pos);
    addif(sw, pos);
    addif(se, pos);
    break;
  case 23: 
    addif(ne, pos);
    addif(se, pos);
    break;
  case 31:
    addif(sw, pos);
    break;
  case 32: 
    addif(sw, pos);
    addif(se, pos);
    break;
  case 33:
    addif(se, pos);
    break;
  }
}

// add the cylinder if it is not over another one in the list
void addif(ArrayList<PVector> obstacles, PVector pos) {
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