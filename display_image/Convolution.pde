PImage convolve(PImage img, float[][] kernel){
  
  PImage res = createImage(img.width,img.height,RGB);

  
  for(int i = 1; i < img.width-1; ++i){
    for(int j = 1; j < img.height - 1; ++j){
      float sum = 0;
       float weight = 0f; 
        for(int k = 0; k < 3; ++k){
          for(int l = 0; l < 3; ++l){
            sum += (kernel[k][l] * brightness(img.get(i+k-1, j+l-1)));
            weight += kernel[k][l];
           }
        }
        sum /= weight;
        res.pixels[i + j*img.width] = color((int)sum);
      
    }
  }
  return res;
}