import java.util.Random; 

PImage img;
float threshold = 128; 
HScrollbar thresholdBar;
HScrollbar secondThresholdBar;
float upperThresh = 134; 
float lowerThresh = 100;
int i = 4; 


void settings() {
  size(1200, 400);
}
void setup() {
  img = loadImage("board" + i + ".jpg");
  noLoop(); // no interactive behaviour: draw() will be called only once.
  thresholdBar = new HScrollbar(0, 580, 800, 20);
  secondThresholdBar = new HScrollbar(0, 540, 800, 20);
}

void draw() {
  //int upperThresh = (int) (thresholdBar.getPos()*255); 
 // int lowerThreshS = (int) (secondThresholdBar.getPos()*255); 
  
  background(0); 
   PImage result = createImage(img.width, img.height, RGB); 

  for (int i = 0; i < result.width * result.height; i++) {
    int hueG = (int)(hue(img.pixels[i]));
    if (hueG <= upperThresh && hueG >= lowerThresh) {
        result.pixels[i] = color(255);
    } else {
        result.pixels[i] = color(0);
    }
    if((brightness(img.pixels[i]) < 6 || brightness(img.pixels[i]) > 250)) {
        result.pixels[i] = color(0); 
    }
    if(saturation(img.pixels[i]) < 100) {
     result.pixels[i] = color(0);  
    }
  }
  
  
  PImage blurResult = convolute(result);
  blurResult.updatePixels(); 
  for (int i = 0; i < blurResult.width * blurResult.height; i++) {
    if (brightness(blurResult.pixels[i]) < 91) {
      blurResult.pixels[i] = color(0);
    } else {
       blurResult.pixels[i] = color(255);
    }
  }
   blurResult.updatePixels(); 

  
 // image(result, 0, 0); 
 // image(sobel(result), 0, 0);

 image(blurResult, 0, 0); 
  
  PImage sobel = sobel(blurResult); 

  sobel.resize(width/3, height); 
  
  image(img, 0, 0, width/3, height); 
 ArrayList<PVector> lines = hough(sobel, 4);
 getIntersections(lines, sobel.width, sobel.height);
   image(sobel, 2*width/3, 0); 

 QuadGraph graph = new QuadGraph(); 
 graph.build(lines, img.width, img.height); 
 List<int[]> quads = graph.findCycles(); 
 
 for (int[] quad : quads) {

  PVector l1 = lines.get(quad[0]);
  PVector l2 = lines.get(quad[1]);
  PVector l3 = lines.get(quad[2]);
  PVector l4 = lines.get(quad[3]);
  
  // (intersection() is a simplified version of the
  // intersections() method you wrote last week, that simply
  // return the coordinates of the intersection between 2 lines)
  PVector c12 = intersection(l1, l2);
  PVector c23 = intersection(l2, l3);
  PVector c34 = intersection(l3, l4);
  PVector c41 = intersection(l4, l1);
    
  if(graph.validArea(c12,c23,c34,c41,3*img.width*img.height/2, 3000) && graph.isConvex(c12,c23,c34,c41) && graph.nonFlatQuad(c12,c23,c34,c41)) {
    // Choose a random, semi-transparent colour
    Random random = new Random();
    fill(color(min(255, random.nextInt(300)),
    min(255, random.nextInt(300)),
    min(255, random.nextInt(300)), 50));
  
    quad(c12.x,c12.y,c23.x,c23.y,c34.x,c34.y,c41.x,c41.y);
  
    
    }
  }
  
  /*thresholdBar.display();
  thresholdBar.update();
  secondThresholdBar.display();
  secondThresholdBar.update(); 
  
 
 if(i == 0) {
  print("low " + lowerThreshS + " and up " + upperThresh);  
 }
 i++; 
 i %= 60; */
  
  

}