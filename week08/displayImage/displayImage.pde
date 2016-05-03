PImage img;
float threshold = 128; 
HScrollbar thresholdBar;
HScrollbar secondThresholdBar;
float upperThresh = 136; 
float lowerThresh = 114; 



void settings() {
  size(800, 600);
}
void setup() {
  img = loadImage("board1.jpg");
  noLoop(); // no interactive behaviour: draw() will be called only once.
  thresholdBar = new HScrollbar(0, 580, 800, 20);
  secondThresholdBar = new HScrollbar(0, 540, 800, 20);
}

void draw() {
  background(0); 
  PImage result = createImage(img.width, img.height, RGB); 
 // result = convolute(result); 
  for (int i = 0; i < result.width * result.height; i++) {
    if (brightness(img.pixels[i]) < 2 || brightness(img.pixels[i]) > 253) {
      result.pixels[i] = color(0);
    } else {
      int hueG = (int)(hue(img.pixels[i]));
      result.pixels[i] = (hueG <= upperThresh && hueG >= lowerThresh) ?  color(255) : color(0);
    }
  }
 // image(result, 0, 0); 
 // image(sobel(result), 0, 0);
  image(img, 0, 0); 
  hough(sobel(result)); 

}

  