PImage sobel(PImage img) {
  PImage result = createImage(img.width, img.height, ALPHA);

  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }

  float max=0;
  float[] buffer = new float[img.width * img.height];
  float hSum = 0; 
  float vSum = 0; 
  float somme = 0; 
 for(int i = 1; i < img.width - 1; ++i) {
   for(int j = 1; j < img.height - 1; ++j)  {
       hSum = 0; 
       vSum = 0; 
       for(int k = -1; k <= 1; k++) {
          for(int l = -1; l <= 1; l++) {
             hSum += brightness(img.get(i + k, j + l)) * hKernel[k + 1][l + 1];
             vSum += brightness(img.get(i + k, j + l)) * vKernel[k + 1][l + 1];
          }
       }
       somme=sqrt(pow(hSum, 2) + pow(vSum, 2)) ;
       max = Math.max(max, somme); 
       buffer[j*img.width + i] = somme; 
   }
 }

  for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
    for (int x = 2; x < img.width - 2; x++) { // Skip left and right
      if (buffer[y * img.width + x] > (int)(max * 0.3f)) { // 30% of the max
        result.pixels[y * img.width + x] = color(255);
      } else {
        result.pixels[y * img.width + x] = color(0);
      }
    }
  }
  return result;
}