import java.util.Random;
import processing.video.*;
Capture cam;
PImage img;
int i = 0;


void settings() {
  size(800, 600);
}
void setup() {
  if (stat) {
    img = loadImage("board1.jpg");
    noLoop(); // no interactive behaviour: draw() will be called only once.
  } else {
    frameRate(2f);
    String[] cameras = Capture.list();
    if (cameras.length == 0) {
      println("There are no cameras available for capture.");
      exit();
    } else {
      /*println("Available cameras:");
       for (int i = 0; i < cameras.length; i++) {
       
       println(cameras[i]);
       }*/
      cam = new Capture(this, cameras[0]);
      cam.start();
    }
  }
}

void draw() {
  if (stat) {
    background(0);
    PImage result = createImage(img.width, img.height, RGB);

    for (int i = 0; i < result.width * result.height; i++) {
      int hueG = (int)(hue(img.pixels[i]));
      if (hueG <= upperThresh && hueG >= lowerThresh) {
        result.pixels[i] = color(255);
      } else {
        result.pixels[i] = color(0);
      }
      if ((brightness(img.pixels[i]) < 6 || brightness(img.pixels[i]) > 250)) {
        result.pixels[i] = color(0);
      }
      if (saturation(img.pixels[i]) < 100) {
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
    
    PImage sobel = sobel(blurResult);
    image(img, 0, 0); 
    
    ArrayList<PVector> lines = hough(sobel, 8);
    intersections = getIntersections(lines, sobel.width, sobel.height);
    // getIntersections(lines, sobel.width, sobel.height);
  

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
      println("c12.x : " + c12.x);
      println("c12.y : " + c12.y);
      PVector c23 = intersection(l2, l3);
      println("c23.x : " + c23.x);
      println("c23.y : " + c23.y);
      PVector c34 = intersection(l3, l4);
      println("c34.x : " + c34.x);
      println("c34.y : " + c34.y);
      PVector c41 = intersection(l4, l1);
      println("c41.x : " + c41.x);
      println("c41.y : " + c41.y);

      if (graph.validArea(c12, c23, c34, c41, 3*img.width*img.height/2, 3000) && graph.isConvex(c12, c23, c34, c41) && graph.nonFlatQuad(c12, c23, c34, c41)) {
        // Choose a random, semi-transparent colour
        Random random = new Random();
        fill(color(min(255, random.nextInt(300)), 
          min(255, random.nextInt(300)), 
          min(255, random.nextInt(300)), 50));

        quad(c12.x, c12.y, c23.x, c23.y, c34.x, c34.y, c41.x, c41.y);
        ArrayList<PVector> corners = new ArrayList<PVector>();
        corners.add(c34);
        corners.add(c41);
        corners.add(c12);
        corners.add(c23);
        
        
        TwoDThreeD t23 = new TwoDThreeD(width, height);
        PVector rot = t23.get3DRotations(corners);
        println("angle x : " + degrees(rot.x));
        println("angle y : " + degrees(rot.y));
        println("angle z : " + degrees(rot.z));
        
      }
    }

  } else {
    //int upperThresh = (int) (thresholdBar.getPos()*255); 
    //int lowerThresh = (int) (secondThresholdBar.getPos()*255); 

    background(0); 
    img = cam.get();
    PImage result = createImage(img.width, img.height, RGB); 

    for (int i = 0; i < result.width * result.height; i++) {
      int hueG = (int)(hue(img.pixels[i]));
      if (hueG <= upperThresh && hueG >= lowerThresh) {
        result.pixels[i] = color(255);
      } else {
        result.pixels[i] = color(0);
      }
      if ((brightness(img.pixels[i]) < 6 || brightness(img.pixels[i]) > 250)) {
        result.pixels[i] = color(0);
      }
      if (saturation(img.pixels[i]) < 100) {
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

    if (cam.available() == true) {
      cam.read();
    }
    PImage sobel = sobel(blurResult);
    image(img, 0, 0); 


    ArrayList<PVector> lines = hough(sobel, 8);
    intersections = getIntersections(lines, sobel.width, sobel.height);
    // getIntersections(lines, sobel.width, sobel.height);
  

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

      if (graph.validArea(c12, c23, c34, c41, 3*img.width*img.height/2, 3000) && graph.isConvex(c12, c23, c34, c41) && graph.nonFlatQuad(c12, c23, c34, c41)) {
        // Choose a random, semi-transparent colour
        Random random = new Random();
        fill(color(min(255, random.nextInt(300)), 
          min(255, random.nextInt(300)), 
          min(255, random.nextInt(300)), 50));

        quad(c12.x, c12.y, c23.x, c23.y, c34.x, c34.y, c41.x, c41.y);
      }
    }
  }
}