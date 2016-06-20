import java.util.*;
import processing.video.*;
import processing.core.PVector;
import papaya.*;

Mover mover;
PGraphics downBar;
PGraphics topView;
PGraphics scoreDisplay;
PGraphics barChart;
ImageProcessing imgproc;

HScrollbar scroll;

Movie cam;

void settings() {
  size(800, 800, P3D);
}


void setup() {
  mover = new Mover();

  make();
  noStroke();
  scroll = new HScrollbar(200, 780, 600, 20);
  downBar = createGraphics(800, 100, P3D);
  topView = createGraphics(100, 100, P3D);
  scoreDisplay = createGraphics(100, 100, P3D);
  barChart = createGraphics(600, 100, P3D);

  cam = new Movie(this, "testvideo.mp4");
  cam.loop();

  img =  loadImage("board1.jpg");

  imgproc = new ImageProcessing();
  String []args = {"Image processing window"};
  PApplet.runSketch(args, imgproc);
}


void draw() {

  background(255);
  noLights();

  fill(255);

  drawDownBar();
  image(downBar, 0, 700);
  drawTopView();
  image(topView, 0, 700);
  drawScore();
  image(scoreDisplay, 100, 700);
  drawbarChart();
  image(barChart, 200, 700); 
  scroll.display();
  scroll.update();

  ambientLight(120, 120, 120); 
  directionalLight(160, 160, 160, -1, 1, 0);
  directionalLight(0, 0, 0, 1, 0, 0);  

  PVector rotation = imgproc.getRotation(); 
  if (shiftMode) {
    /*in shift mode we want to add cylinders to the plate
     */

    translate(width/2, height/2, 0); 
    //add the sphere in the shift mode
    pushMatrix();
    translate(mover.location.x, mover.location.z, mover.location.y);
    fill(255, 0, 0);
    sphere(radius);
    popMatrix();
    //end of the sphere part

    fill(255);
    box(boxXZ, boxXZ, boxY); 
    for (PVector o : obstacles) {
      fill(100);
      drawCylinder(o.x, o.y, 0, shiftMode);
    }
    fill(100);
    drawCylinder(mouseX - width/2, mouseY - height/2, 0, shiftMode);
  } else {
    /*in this mode we want to drag the plate to move the ball
     */
    // Setting the angles according to the video. Done it this way in order to make the transitions smoother. 
    // If a difference between an angle and the next is too abrupt, we consider it a detection error, and only account it for a little part.
    if (abs(rotation.x - angleX) < PI/3) {
      angleX = 0.3*angleX + 0.7*rotation.x; 
      angleX = rotation.x > 0 ? min(angleX, PI/3) : max(angleX, -PI/3);
    } else {
      angleX = 0.9*angleX + 0.1*rotation.x;
    }
    if (abs(rotation.z - angleZ) < PI/3) {
      angleZ = 0.3*angleZ + 0.7*rotation.z; 
      angleZ = rotation.z > 0 ? min(angleZ, PI/3) : max(angleZ, -PI/3);
    } else {
      angleZ = 0.9*angleZ + 0.1*rotation.z;
    }
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

// Called every time a new frame is available to read
void movieEvent(Movie m) {
  m.read();
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
      addif(obstacles, pos);
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

void updateScore(float gain) {
  previousScore = score;
  score += gain;
}