PImage img;
PImage result;
PImage resultFiltred;

float threshold =128;
float uBound=136;
float lBound=114;

HScrollbar scroll;
HScrollbar scr;

void settings() {
  size(800, 600);
}
void setup() {
  img = loadImage("board1.jpg");

  result = createImage(img.width, img.height, RGB);
  resultFiltred = createImage(img.width, img.height, RGB);
  /*scroll = new HScrollbar(0, 580, 800, 20);
  scr = new HScrollbar(0,500,800,20);*/
 // premier filtre

  for (int i = 0; i < img.width * img.height; i++) {
    if (brightness(img.pixels[i]) > 250 || brightness(img.pixels[i]) < 5) {
      resultFiltred.pixels[i] =color(0);
    } else {
      resultFiltred.pixels[i]=img.pixels[i];
    }
  }

  for (int i = 0; i < img.width * img.height; i++) {
    if (hue(resultFiltred.pixels[i]) < uBound && hue(resultFiltred.pixels[i]) > lBound) {
      result.pixels[i] =color(255);
    } else {
      result.pixels[i]=color(0, 0, 0);
    }
  }
  //noLoop(); // no interactive behaviour: draw() will be called only once.
}
void draw() {
  background(color(0, 0, 0));

  
  float[][] kernel = {{0.75f,2f,0.75f},{1f,2.5f,1f},{0.75f,2f,0.75f}};
    //image(resultFiltred, 0, 0);
    //image(result, 0, 0);
    image(hough(sobel(result)), 0, 0);
 
  
}