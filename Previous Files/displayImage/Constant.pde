//Constant for displayImage

//the hue threshold
float upperThresh = 134; 
float lowerThresh = 100;

//brightness threshold
float brightnessLow = 6;
float brightnessHigh = 250;

//saturation threshold 
float saturationTresh = 100;

//intensity threshold
float intensityTresh = 91;

//minimum area for selecting quad 
float minimumArea = 3000;

//constants for convolution

float[][] kernel = { { 9, 12, 9 }, 
  { 12, 15, 12 }, 
  { 9, 12, 9 }};

float weight = 0.f;

//constant for hough

int minVotes = 50;

int neighbourhood = 10;

//constant for Sobel

float[][] hKernel = { { 0, 1, 0 }, 
  { 0, 0, 0 }, 
  { 0, -1, 0 } };

float[][] vKernel = { { 0, 0, 0 }, 
  { 1, 0, -1 }, 
  { 0, 0, 0 } };
  
  ArrayList<PVector> intersections;
  QuadGraph graph = new QuadGraph();

boolean stat = true;