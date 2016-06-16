import java.util.Random;
import processing.video.*;



public class ImageProcessing extends PApplet {
  PImage result; 
  TwoDThreeD t23;

  public void settings() {
    size(800, 600);
  }

  public void setup() {
    //  img = loadImage("C:\\Users\\Sébastien\\Desktop\\EPFL\\BA4\\ProgVisu\\Projet\\Rendu Final\\Game\\data\\board1.jpg");


    t23 = new TwoDThreeD(img.width, img.height);
  }

  public void draw() {
    background(255); 
    img = cam.get();   
    img.loadPixels(); 
    result = createImage(img.width, img.height, RGB);
    result.loadPixels(); 
    
    for (int i = 0; i < result.width * result.height; i++) {
      int hueG = (int)(hue(img.pixels[i]));
      if (hueG >= 100 && hueG <= 134) {
        result.pixels[i] = color(255);
      } else {
        result.pixels[i] = color(0);
      }
      if ((brightness(img.pixels[i]) < 6 || brightness(img.pixels[i]) > 250)) {
        result.pixels[i] = color(0);
      }
      if (saturation(img.pixels[i]) < 175) {
        result.pixels[i] = color(0);
      }
    }
    result.updatePixels(); 

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
    image(img, 0, 0, 400, 600);
    image(result, 400, 0, 400, 600); 

    ArrayList<PVector> lines = hough(sobel, 6);
    intersections = getIntersections(lines, sobel.width, sobel.height);
    print(intersections.size() + "  ; "); 
    getIntersections(lines, sobel.width, sobel.height);


    graph.build(lines, img.width, img.height); 
    List<int[]> quads = graph.findCycles(); 

    print(quads.size() + " <- s "); 

    float maxArea = 0; 
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

        maxArea = graph.area(c12, c23, c34, c41); 
        print(maxArea); 
        quad(c12.x, c12.y, c23.x, c23.y, c34.x, c34.y, c41.x, c41.y);
        ArrayList<PVector> corners = new ArrayList<PVector>();
        corners.add(c34);
        corners.add(c41);
        corners.add(c12);
        corners.add(c23);

        QuadGraph q = new QuadGraph();

        List<PVector> co = q.sortCorners(corners);

        print(co.size()); 

        rot = t23.get3DRotations(co);
      }
    }
    //  print(rot.x + " , " + rot.y);
  }
  PVector getRotation() {
    return rot;
  }

} 