PImage sobel(PImage img) {
  float[][] hKernel = { { 0, 1, 0 }, 
    { 0, 0, 0 }, 
    { 0, -1, 0 } };
  float[][] vKernel = { { 0, 0, 0 }, 
    { 1, 0, -1 }, 
    { 0, 0, 0 } };
  PImage result = createImage(img.width, img.height, ALPHA);
  // clear the image
  for (int i = 0; i < img.width * img.height; i++) {
    result.pixels[i] = color(0);
  }
  float max=0;
  float[] buffer = new float[img.width * img.height];
  // *************************************
  // Implement here the double convolution
  // *************************************
  
  
  for(int i = 1; i < img.width - 1; ++i){
    for(int j = 1; j < img.height-1; ++j){
      float sumV = 0f;
      float sumH = 0f;
      for(int k = 0; k < 3; ++k){
          for(int l = 0; l < 3; ++l){
            sumV += (vKernel[k][l] * brightness(img.get(i+k-1, j+l-1)));
            sumH += (hKernel[k][l] * brightness(img.get(i+k-1, j+l-1)));
           }
        }
        
      float totalSum = (float)Math.sqrt(sumV*sumV + sumH*sumH);
      max = Math.max(max, totalSum);
      buffer[i + j*img.width] = totalSum;
    }
  }
 
  
  for (int y = 2; y < img.height - 2; y++) { // Skip top and bottom edges
    for (int x = 2; x < img.width - 2; x++) { // Skip left and right
      if (buffer[y * img.width + x] > (int)(max * 0.2f)) { // 30% of the max
        result.pixels[y * img.width + x] = color(255);
      } else {
        result.pixels[y * img.width + x] = color(0);
      }
    }
  }
  return result;
}