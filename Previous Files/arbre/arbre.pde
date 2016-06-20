void settings() {
  size(400, 800, P2D);
}
void setup() {
  float red = random(0,255);
//  float green = random(0,255);
//  float blue = random(0,255);
  background(red);
  noLoop();
}
void draw() {
  plant(15, 0.4, 0.8);
}
void leaf() {
  beginShape();
  float red = random(75,200);
  float green = random(0,150);
  float blue = random(0,100);
  fill(red,green,blue);
  stroke(red,green,blue);
  vertex(100.0, -70.0);
  bezierVertex(90.0, -60.0, 100.0, -100.0, 0.0, 0.0);
  // forme toute moche!!!
  bezierVertex(0.0, 0.0, 100.0, 40.0, 100.0, -70.0);
  endShape();
}
void plant(int numLeaves, float minLeafScale, float maxLeafScale) {
  stroke(200,100,100);
  line(width/2, 0, width/2, height); // the plant's stem
  int gap = height/numLeaves; // vertical spacing between leaves
  float angle = 0;
  for (int i=0; i<numLeaves; i++) {
    int x = width/2;
    int y = gap*i + (int)random(gap);
    float scale = random(minLeafScale, maxLeafScale);
    pushMatrix();
    translate(x, y);
    scale(scale);
    rotate(angle);
    leaf();
    popMatrix();
    angle += PI; // alternate the side for each leaf
  }
}