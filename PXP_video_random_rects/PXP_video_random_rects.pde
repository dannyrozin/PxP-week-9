// The world pixel by pixel 2021
// Daniel Rozin
// places random rects of video on screen, mouseX determines shake
import processing.video.*;
Movie ourMovie;                          // variable to hold the video
void setup() {
  size(480, 360);
  ourMovie = new Movie(this, "virtual.mp4"); 
  ourMovie.loop();
  noFill();
  strokeWeight(1);
  frameRate(60);
}

void draw() {
  int shake = (int) map(mouseX, 0, width, 0, 50);
  int x = (int) random ( 0, width);
  int y = (int)random ( 0, width);
  int w =(int)random ( 50, 200);
  int h =(int)random ( 50, 200);
  
  int targetX=  x + (int)random(-shake, shake);
  int targetY=  y + (int)random(-shake, shake);
  int targetW=  w + (int)random(-shake, shake);
  int targetH=  h + (int)random(-shake, shake);
  copy(ourMovie, x, y, w, h, targetX, targetY, targetW, targetH);

  stroke (0);
  rect(targetX, targetY, w, h);
  stroke (255);
  line (targetX, targetY, targetX+w, targetY);
  line (targetX, targetY, targetX, targetY+h);
}

void movieEvent(Movie m) {              //  callback function that reads a frame whenever its ready
  m.read();
}
