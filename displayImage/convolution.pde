PImage convolute(PImage img) {

  // create a greyscale image (type: ALPHA) for output
  PImage result = createImage(img.width, img.height, RGB);

  int N = 3;
  int reduction = floor(N/2); 
  int somme = 0; 
  
  //
  // for each (x,y) pixel in the image:
  // - multiply intensities for pixels in the range
  // (x - N/2, y - N/2) to (x + N/2, y + N/2) by the
  // corresponding weights in the kernel matrix
  // - sum all these intensities and divide it by the weight
  // - set result.pixels[y * img.width + x] to this value
  
 for(int i = reduction; i < img.width - reduction; ++i) {
   for(int j = reduction; j < img.height - reduction; ++j)  {
       somme = 0; 
       weight = 0.f; 
       for(int k = -1; k <= 1; k++) {
          for(int l = -1; l <= 1; l++) {
             somme += brightness(img.get(i + k, j + l)) * kernel[k + 1][l + 1];
             weight += kernel[k+1][l+1];
          }
       }
       
       somme /= weight; 
       result.pixels[j*img.width + i] = color(somme); 
   }
 }

  return result;
}