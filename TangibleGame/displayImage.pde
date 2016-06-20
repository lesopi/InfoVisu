public class ImageProcessing extends PApplet {
  PImage result; 
  TwoDThreeD t23;

  public void settings() {
    size(cam.get().width, cam.get().height);
  }

  public void setup() {
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
    image(img, 0, 0);


    ArrayList<PVector> lines = hough(sobel, 6);
    intersections = getIntersections(lines, sobel.width, sobel.height);
    getIntersections(lines, sobel.width, sobel.height);


    graph.build(lines, img.width, img.height); 
    List<int[]> quads = graph.findCycles(); 

    int[] bestQuad = {0, 0, 0, 0};
    if (quads.size() > 0) {
      bestQuad = quads.get(0);
    }


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
      PVector c23 = intersection(l2, l3);
      PVector c34 = intersection(l3, l4);
      PVector c41 = intersection(l4, l1);

      float gArea = graph.area(c12, c23, c34, c41); 

      if (graph.validArea(c12, c23, c34, c41, 3*img.width*img.height/2, 3000) && graph.isConvex(c12, c23, c34, c41) && graph.nonFlatQuad(c12, c23, c34, c41) && maxArea < gArea) {
        maxArea = gArea; 
        bestQuad = quad;
      }
    }

    if (quads.size() > 0) {
      PVector l1 = lines.get(bestQuad[0]);
      PVector l2 = lines.get(bestQuad[1]);
      PVector l3 = lines.get(bestQuad[2]);
      PVector l4 = lines.get(bestQuad[3]);

      PVector c12 = intersection(l1, l2);
      PVector c23 = intersection(l2, l3);
      PVector c34 = intersection(l3, l4);
      PVector c41 = intersection(l4, l1);

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
      QuadGraph q = new QuadGraph();

      List<PVector> co = q.sortCorners(corners);
      t23 = new TwoDThreeD(img.width, img.height);

      rot = t23.get3DRotations(co);

      println(degrees(rot.x) + " , " + degrees(rot.y) + " , " + degrees(rot.z));
    }
  }
  PVector getRotation() {
    return rot;
  }


  PImage convolute(PImage img) {


    float[][] kernel = {{0, 0, 0, 5, 0, 0, 0}, 
      {0, 5, 18, 32, 18, 5, 0}, 
      {0, 18, 64, 100, 64, 18, 0}, 
      {5, 32, 100, 100, 100, 32, 5}, 
      {0, 18, 64, 100, 64, 18, 0}, 
      {0, 5, 18, 32, 18, 5, 0}, 
      {0, 0, 0, 5, 0, 0, 0}
    };
    /* float[][] kernel = { { 9, 12, 9 }, 
     { 12, 15, 12 }, 
     { 9, 12, 9 }};
     
    /*float[][] kernel = { { 0, 0, 0 }, 
     { 0, 2, 0 }, 
     { 0, 0, 0 }};*/
    float weight = 1.f;

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

    for (int i = reduction; i < img.width - reduction; ++i) {
      for (int j = reduction; j < img.height - reduction; ++j) {
        somme = 0; 
        weight = 0.f; 
        for (int k = -1; k <= 1; k++) {
          for (int l = -1; l <= 1; l++) {
            somme += brightness(img.get(i + k, j + l)) * kernel[k + 1][l + 1];
            weight += kernel[k+1][l+1];
          }
        }

        somme /= weight; 
        result.pixels[j*img.width + i] = color(somme);
      }
    }
    result.updatePixels(); 
    return result;
  }

  ArrayList<PVector> hough(PImage edgeImg, int nLines) {
    ArrayList<PVector> lines = new ArrayList<PVector>();
    float discretizationStepsPhi = 0.06f;
    float discretizationStepsR = 2.5f;
    // dimensions of the accumulator
    int phiDim = (int) (Math.PI / discretizationStepsPhi);
    int rDim = (int) (((edgeImg.width + edgeImg.height) * 2 + 1) / discretizationStepsR);

    // our accumulator (with a 1 pix margin around)
    int[] accumulator = new int[(phiDim + 2) * (rDim + 2)];
    ArrayList<Integer> candidates = new ArrayList<Integer>();

    // pre-compute the sin and cos values
    float[] tabSin = new float[phiDim];
    float[] tabCos = new float[phiDim];
    float ang = 0;
    float inverseR = 1.f / discretizationStepsR;
    for (int accPhi = 0; accPhi < phiDim; ang += discretizationStepsPhi, accPhi++) {
      // we can also pre-multiply by (1/discretizationStepsR) since we need it in the Hough loop
      tabSin[accPhi] = (float) (Math.sin(ang) * inverseR);
      tabCos[accPhi] = (float) (Math.cos(ang) * inverseR);
    }

    // Fill the accumulator: on edge points (ie, white pixels of the edge
    // image), store all possible (r, phi) pairs describing lines going
    // through the point.
    for (int y = 0; y < edgeImg.height; y++) {
      for (int x = 0; x < edgeImg.width; x++) {
        // Are we on an edge?
        if (brightness(edgeImg.pixels[y * edgeImg.width + x]) != 0) {

          for (int i = 0; i < phiDim; ++i) {
            float phi = (float)(i*discretizationStepsPhi);
            float r = x*tabCos[i] + y*tabSin[i]; 
            r += (rDim - 1)/2;

            accumulator[((i+1)*(rDim+2) + (int)(r+1))] += 1;
          }
          // ...determine here all the lines (r, phi) passing through
          // pixel (x,y), convert (r,phi) to coordinates in the
          // accumulator, and increment accordingly the accumulator.

          // Be careful: r may be negative, so you may want to center onto
          // the accumulator with something like: r += (rDim - 1) / 2
        }
      }
    }

    PImage houghImg = createImage(rDim + 2, phiDim + 2, ALPHA);

    for (int i = 0; i < accumulator.length; i++) {
      houghImg.pixels[i] = color(min(255, accumulator[i]));
    }

    // You may want to resize the accumulator to make it easier to see:
    houghImg.resize(400, 400);

    houghImg.updatePixels();
    /*for (int idx = 0; idx < accumulator.length; idx++) {
     if(accumulator[idx] > minVotes){
     candidates.add(idx);
     }
     }*/

    // size of the region we search for a local maximum
    int neighbourhood = 10;
    // only search around lines with more that this amount of votes // (to be adapted to your image)
    int minVotes = 200;
    for (int accR = 0; accR < rDim; accR++) {
      for (int accPhi = 0; accPhi < phiDim; accPhi++) {
        // compute current index in the accumulator
        int idx = (accPhi + 1) * (rDim + 2) + accR + 1;
        if (accumulator[idx] > minVotes) {
          boolean bestCandidate=true;
          // iterate over the neighbourhood

          for (int dPhi=-neighbourhood/2; dPhi < neighbourhood/2+1; dPhi++) { // check we are not outside the image
            if ( accPhi+dPhi < 0 || accPhi+dPhi >= phiDim) continue;
            for (int dR=-neighbourhood/2; dR < neighbourhood/2 +1; dR++) {
              // check we are not outside the image
              if (accR+dR < 0 || accR+dR >= rDim) continue;
              int neighbourIdx = (accPhi + dPhi + 1) * (rDim + 2) + accR + dR + 1;
              if (accumulator[idx] < accumulator[neighbourIdx]) { // the current idx is not a local maximum! 
                bestCandidate=false;
                break;
              }
            }
            if (!bestCandidate) break;
          }
          if (bestCandidate) {
            // the current idx *is* a local maximum 
            candidates.add(idx);
          }
        }
      }
    }

    Collections.sort(candidates, new HoughComparator(accumulator));
    for (int i = 0; i< min(nLines, candidates.size()); ++i) {   
      //if (accumulator[idx] > 200) {
      int idx = candidates.get(i);


      // first, compute back the (r, phi) polar coordinates:

      int accPhi = (int) (idx / (rDim + 2)) - 1;
      int accR = idx - (accPhi + 1) * (rDim + 2) - 1;
      float r = (accR - (rDim - 1) * 0.5f) * discretizationStepsR;
      float phi = accPhi * discretizationStepsPhi;

      lines.add(new PVector(r, phi));


      // Cartesian equation of a line: y = ax + b
      // in polar, y = (-cos(phi)/sin(phi))x + (r/sin(phi))
      // => y = 0 : x = r / cos(phi)
      // => x = 0 : y = r / sin(phi)

      // compute the intersection of this line with the 4 borders of
      // the image
      int x0 = 0;
      int y0 = (int) (r*inverseR /tabSin[accPhi]);
      int x1 = (int) (r*inverseR /tabCos[accPhi]);
      int y1 = 0;
      int x2 = edgeImg.width;
      int y2 = (int) (-(tabCos[accPhi]/inverseR) / (tabSin[accPhi]/inverseR) * x2 + r / (tabSin[accPhi]/inverseR));
      int y3 = edgeImg.width;
      int x3 = (int) (-(y3 - r / (tabSin[accPhi]/inverseR)) * ((tabSin[accPhi]/inverseR) / (tabCos[accPhi]/inverseR)));

      // Finally, plot the lines
      stroke(204, 102, 0);
      if (y0 > 0) {
        if (x1 > 0)
          line(x0, y0, x1, y1);
        else if (y2 > 0)
          line(x0, y0, x2, y2);
        else
          line(x0, y0, x3, y3);
      } else {
        if (x1 > 0) {
          if (y2 > 0)
            line(x1, y1, x2, y2);
          else
            line(x1, y1, x3, y3);
        } else
          line(x2, y2, x3, y3);
      }
    } 
    return lines;
  }

  ArrayList<PVector> getIntersections(ArrayList<PVector> lines, int w, int h) {
    ArrayList<PVector> intersections = new ArrayList<PVector>();
    for (int i = 0; i < lines.size() - 1; i++) {
      PVector line1 = lines.get(i);
      for (int j = i + 1; j < lines.size(); j++) {
        PVector line2 = lines.get(j);
        // compute the intersection and add it to ’intersections’
        // draw the intersection
        float d = cos(line2.y) * sin(line1.y) - cos(line1.y) * sin(line2.y);
        float x = (line2.x*sin(line1.y) - line1.x*sin(line2.y))/d;

        float y = (-line2.x*cos(line1.y) + line1.x*cos(line2.y))/d;

        if (x > 0 && y > 0 && x < w && y < h ) {
          fill(255, 128, 0);
          ellipse(x, y, 10, 10);
          PVector ret = new PVector(x, y);
          intersections.add(ret);
        }
      }
    }
    return intersections;
  }

  PVector intersection(PVector line1, PVector line2) {
    float d = cos(line2.y) * sin(line1.y) - cos(line1.y) * sin(line2.y);
    float x = (line2.x*sin(line1.y) - line1.x*sin(line2.y))/d;
    float y = (-line2.x*cos(line1.y) + line1.x*cos(line2.y))/d;

    return new PVector(x, y);
  }

  PImage sobel(PImage img) {
    //image(img, 0, 0);

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
    for (int i = 1; i < img.width - 1; ++i) {
      for (int j = 1; j < img.height - 1; ++j) {
        hSum = 0; 
        vSum = 0; 
        for (int k = -1; k <= 1; k++) {
          for (int l = -1; l <= 1; l++) {
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
    //image(result, 600, 0);
    return result;
  }
} 