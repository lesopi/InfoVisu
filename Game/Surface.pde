float ratio = boxXZ/100;
//bar for display of information
//week 06
/*void drawDownBar(){
  downBar.beginDraw();
  downBar.background(236,250,177);
  downBar.endDraw();
}

//display the top view
void drawTopView(){
  topView.beginDraw();
  topView.background(#333E95);
  
    topView.fill(255,0,0);
    topView.scale(1.0/ratio);
    topView.ellipse(mover.location.x+ boxXZ/2,mover.location.z + boxXZ/2 ,2*radius,2*radius);
  for(int i = 0; i < obstacles.size(); ++i){
      topView.fill(0);
      topView.ellipse(obstacles.get(i).x+boxXZ/2, obstacles.get(i).y+boxXZ/2, 2*cylinderBaseSize,2*cylinderBaseSize);
  }
  
  topView.endDraw();
}

//display the score

void drawScore(){
  scoreDisplay.beginDraw();
  scoreDisplay.background(236,250,177);
  scoreDisplay.fill(0);
  scoreDisplay.text("Total score \n: "+score+"\n\nVelocity:\n"+mover.velocity.mag()+"\n\nLast score:\n"+previousScore, 10,10);
  scoreDisplay.endDraw();
}*/