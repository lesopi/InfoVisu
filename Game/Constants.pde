//represent fow rotated is the plate in direction X or Z
float angleX = 0.0; 
float angleZ = 0.0; 

//change the speed of the rotation of the plate
float speed = 1.0; 

//position of the plate before a mousedragged
//updated when a mouseDragged occure
float posX = 0.0; 
float posY = 0.0;

//radius of our sphere
float radius = 20;

// physic constants
float gravityConstant = 0.327;
float mu = 0.01;
float rebondcoeff = 0.5;

//size of our sqare plate
float boxXZ = 500;
float boxY = 10;

//if true the user can add cylinder to the plate
boolean shiftMode= false;

//contains the all the cylinder the user sets during shiftMode
ArrayList<PVector> obstacles = new ArrayList<PVector>();

//constant for the cylinder construction
float cylinderBaseSize = 15;
float cylinderHeight = 30;
int cylinderResolution = 40;