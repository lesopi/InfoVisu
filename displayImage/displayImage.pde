import java.util.Random; 

PImage img;


void settings() {
  //if the resolution of your computer is smaller you can replace with this resolution
  //size(1200,300)
  size(1800, 450);
}
void setup() {
  img = loadImage("board1.jpg");
  noLoop(); // no interactive behaviour: draw() will be called only once.
}

void draw() {
  background(0); 
  PImage result = createImage(img.width, img.height, RGB); 
  
  //filter in function of hue of the image, the idea is to keep the green pixel
  //of the image 
  //it also applies a filter on the brigthness to avoid too luminous and too dark spot of the image
  //applies after that a saturation filter to keep only the vivid pixels
  for (int i = 0; i < result.width * result.height; i++) {
    int hueG = (int)(hue(img.pixels[i]));
    if (hueG <= upperThresh && hueG >= lowerThresh) {
      result.pixels[i] = color(255);
    } else {
      result.pixels[i] = color(0);
    }
    if ((brightness(img.pixels[i]) < brightnessLow || brightness(img.pixels[i]) > brightnessHigh)) {
      result.pixels[i] = color(0);
    }
    if (saturation(img.pixels[i]) < saturationTresh) {
      result.pixels[i] = color(0);
    }
  }

//blur the image and remove the pixel with high brightness
  PImage blurResult = convolute(result);
  blurResult.updatePixels(); 
  for (int i = 0; i < blurResult.width * blurResult.height; i++) {
    if (brightness(blurResult.pixels[i]) < intensityTresh) {
      blurResult.pixels[i] = color(0);
    } else {
      blurResult.pixels[i] = color(255);
    }
  }
  blurResult.updatePixels(); 


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

    if (graph.validArea(c12, c23, c34, c41, 3*img.width*img.height/2, minimumArea) && graph.isConvex(c12, c23, c34, c41) && graph.nonFlatQuad(c12, c23, c34, c41)) {
      // Choose a random, semi-transparent colour
      Random random = new Random();
      fill(color(min(255, random.nextInt(300)), 
        min(255, random.nextInt(300)), 
        min(255, random.nextInt(300)), 50));

      quad(c12.x, c12.y, c23.x, c23.y, c34.x, c34.y, c41.x, c41.y);
    }
  }
}