import processing.video.*;
Capture cam;
PImage img;
float threshold = 128; 
HScrollbar thresholdBar;
HScrollbar secondThresholdBar;
float upperThresh = 134; 
float lowerThresh = 116; 
float lowIntensity = 200;
float highIntensity = 255; 



void settings() {
  size(800, 600);
}
void setup() {
  //frameRate(2);
  img = loadImage("board1.jpg");
  noLoop(); // no interactive behaviour: draw() will be called only once.
  thresholdBar = new HScrollbar(0, 580, 800, 20);
  secondThresholdBar = new HScrollbar(0, 540, 800, 20);
  /*String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new Capture(this, cameras[0]);
    cam.start(); 
  }*/
}

void draw() {
  //int upperThresh = (int) (thresholdBar.getPos()*255); 
  //int lowerThresh = (int) (secondThresholdBar.getPos()*255); 
  
  background(0); 
 // img = cam.get();
   PImage result = createImage(img.width, img.height, RGB); 

  // result = convolute(result); 
  for (int i = 0; i < result.width * result.height; i++) {
    if (brightness(img.pixels[i]) < 6 || brightness(img.pixels[i]) > 250) {
      result.pixels[i] = color(0);
    } else {
      int hueG = (int)(hue(img.pixels[i]));
      result.pixels[i] = (hueG <= upperThresh && hueG >= lowerThresh) ?  color(255) : color(0);
    }
  }
  result  = convolute(result); 
  
  for (int i = 0; i < result.width * result.height; i++) {
    
      result.pixels[i] = (brightness(img.pixels[i]) <= upperThresh && brightness(img.pixels[i]) >= lowerThresh) ?  color(255) : color(0);
    
  }

  
  
 // image(result, 0, 0); 
 // image(sobel(result), 0, 0);
/*  if (cam.available() == true) {
    cam.read();
  } */
  
  
  image(img, 0, 0); 
  ArrayList<PVector> v = hough(sobel(result), 4);
  getIntersections(v);
  
  //thresholdBar.display();
  //thresholdBar.update();
  //secondThresholdBar.display();
  //secondThresholdBar.update();
  
  

}

/*import processing.video.*;
Capture cam;
PImage img;
float threshold = 128; 
HScrollbar thresholdBar;
HScrollbar secondThresholdBar;
float upperThresh = 126; 
float lowerThresh = 114; 



void settings() {
  size(800, 600);
}
void setup() {
  //frameRate(2);
  //img = loadImage("board1.jpg");
  //noLoop(); // no interactive behaviour: draw() will be called only once.
  thresholdBar = new HScrollbar(0, 580, 800, 20);
  secondThresholdBar = new HScrollbar(0, 540, 800, 20);
  String[] cameras = Capture.list();
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
}

void draw() {
  //int upperThresh = (int) (thresholdBar.getPos()*255); 
  //int lowerThresh = (int) (secondThresholdBar.getPos()*255); 
  
  background(0); 
  img = cam.get();
   PImage result = createImage(img.width, img.height, RGB); 
  // result = convolute(result); 
  for (int i = 0; i < result.width * result.height; i++) {
    if (brightness(img.pixels[i]) < 6 || brightness(img.pixels[i]) > 250) {
      result.pixels[i] = color(0);
    } else {
      int hueG = (int)(hue(img.pixels[i]));
      result.pixels[i] = (hueG <= upperThresh && hueG >= lowerThresh) ?  color(255) : color(0);
    }
  }
 // image(result, 0, 0); 
 // image(sobel(result), 0, 0);
  if (cam.available() == true) {
    cam.read();
  }
  
  image(img, 0, 0); 
  ArrayList<PVector> v = hough(sobel(result), 4);
  getIntersections(v);
  
  //thresholdBar.display();
  //thresholdBar.update();
  //secondThresholdBar.display();
  //secondThresholdBar.update();
  
  

}*/