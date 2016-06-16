//Constant for displayImage

PVector rot = new PVector(0, 0, 0); 

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

int minVotes = 30;

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

boolean stat = false;

//Constants for the game

PImage img; 
//represent fow rotated is the plate in direction X or Z
float angleX; 
float angleZ; 

//change the speed of the rotation of the plate
float speed = 1.0; 

//position of the plate before a mousedragged
//updated when a mouseDragged occure
float posX = 0.0; 
float posY = 0.0;

//radius of our sphere
float radius = 13;

// physic constants
float gravityConstant = 0.2;
float mu = 0.01;
float rebondcoeff = 0.5;

//size of our sqare plate
float boxXZ = 500;
float boxY = 10;

//if true the user can add cylinder to the plate
boolean shiftMode= false;

//ratio for surface drawing
float ratio = boxXZ/100;

//contains the all the cylinder the user sets during shiftMode
ArrayList<PVector> obstacles = new ArrayList<PVector>();
ArrayList<PVector> nw = new ArrayList<PVector>();
ArrayList<PVector> ne = new ArrayList<PVector>();
ArrayList<PVector> sw = new ArrayList<PVector>();
ArrayList<PVector> se = new ArrayList<PVector>();

//constant for the cylinder construction
float cylinderBaseSize = 25;
float cylinderHeight = 50;
int cylinderResolution = 40;


//keeps score 
float score = 0.0;
float previousScore = 0.0;


// height of the bottom surface
int bSH = 100;

//height and width of a rectangle in the barchart
float widthChart = 2;
float heightChart = 2;

//contains the hight of the score at a given time
ArrayList<Integer> carre = new ArrayList<Integer>();
//contains the second that already corresponds to a score (until one hour)
HashSet<Integer> secondes = new HashSet<Integer>();
//number of score we display in the bar chart
int numberToDisplay = 100;
//sampling value, every x value we save the score into carre ArrayList
int sample = 2;
//to what value correspond one square of the score 
int valueSquare = 10;