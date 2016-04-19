// modelize the 3 parts of a cylinder
PShape openCylinder = new PShape();
PShape topCylinder = new PShape();
PShape bottomCylinder = new PShape();

// all the points at the edges of the cylinder
float angle;
float[] x = new float[cylinderResolution + 1];
float[] y = new float[cylinderResolution + 1];

// instantiate the PShape as parts of the cylinder
void make() {
  //get the x and y position on a circle for all the sides
  for (int i = 0; i < x.length; i++) {
    angle = (TWO_PI / cylinderResolution) * i;
    x[i] = sin(angle) * cylinderBaseSize;
    y[i] = cos(angle) * cylinderBaseSize;
  }

  //draw the border of the cylinder
  openCylinder = createShape();
  openCylinder.beginShape(QUAD_STRIP);
  for (int i = 0; i < x.length; i++) {
    openCylinder.vertex(x[i], y[i], 0);
    openCylinder.vertex(x[i], y[i], cylinderHeight);
  }
  openCylinder.endShape();


  //draw the top of the cylinder
  topCylinder = createShape();
  topCylinder.beginShape(TRIANGLES);
  for (int j = 0; j< x.length; j++) {
    topCylinder.vertex(x[j], y[j], cylinderHeight);
    topCylinder.vertex(x[(j+1)%x.length], y[(j+1)%x.length], cylinderHeight);
    topCylinder.vertex(0, 0, cylinderHeight);
  }
  topCylinder.endShape();

  //draw the bottom of the cylinder
  bottomCylinder = createShape();
  bottomCylinder.beginShape(TRIANGLES);
  for (int j = 0; j< x.length; j++) {
    bottomCylinder.vertex(x[j], y[j], 0);
    bottomCylinder.vertex(x[(j + 1) % x.length], y[(j + 1) % x.length], 0);
    bottomCylinder.vertex(0, 0, 0);
  }
  bottomCylinder.endShape();
}


 /*
 * pX, pY, pZ: the position where we want the (bottom) center of the cylinder to be
 * shift: if we are in shift mode we need to rotate the cylinder
 */
void drawCylinder(float pX, float pY, float pZ, boolean shift) {
 
  pushMatrix();
  translate(pX, pY, pZ);

  // rotate so that the cylinders have base on the plate
  if (! shift) {
    rotateX(PI / 2);
  }

  // put the parts together
  shape(openCylinder);
  shape(bottomCylinder);
  shape(topCylinder);
  popMatrix();
}