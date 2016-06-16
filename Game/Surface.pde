//bar for display of information

void drawDownBar() {
  downBar.beginDraw();
  downBar.background(236, 250, 177);
  downBar.endDraw();
}

//display the top view
void drawTopView() {
  topView.beginDraw();
  topView.background(#333E95);

  topView.fill(255, 0, 0);
  topView.scale(1.0/ratio);
  topView.ellipse(mover.location.x+ boxXZ/2, mover.location.z + boxXZ/2, 2*radius, 2*radius);
  for (int i = 0; i < obstacles.size(); ++i) {
    topView.fill(0);
    topView.ellipse(obstacles.get(i).x+boxXZ/2, obstacles.get(i).y+boxXZ/2, 2*cylinderBaseSize, 2*cylinderBaseSize);
  }

  topView.endDraw();
}

//display the score

void drawScore() {
  scoreDisplay.beginDraw();
  scoreDisplay.background(236, 250, 177);
  scoreDisplay.fill(0);
  scoreDisplay.text("Total score \n: "+score+"\n\nVelocity:\n"+mover.velocity.mag()+"\n\nLast score:\n"+previousScore, 10, 10);
  scoreDisplay.endDraw();
}

void drawbarChart() {
  barChart.beginDraw();
  barChart.background(#FAF2F2);
  widthChart = 8*scroll.getPos();
  int sec = second();
  if (sec % sample == 0 &&  !secondes.contains(sec+60*minute()) && !shiftMode) {
    secondes.add(sec+60*minute());
    carre.add((int)score/valueSquare);
  }
  int size = carre.size();
  for (int i = size-1; i >=Math.max(0,size-numberToDisplay); --i) {
      for (int j = 0; j < carre.get(i); ++j) {
        barChart.fill(0, 0, 255);
        barChart.rect(0+(i-Math.max(0,size-numberToDisplay))*widthChart, 67-Math.min(j*heightChart,80), widthChart, heightChart);
      }
    }
    
  barChart.endDraw();
}