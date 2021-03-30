// The world pixel by pixel 2021
// Daniel Rozin
// glitches video by places random rects of video on screen,
// and changing blend modes,  no interaction
import processing.video.*;
Movie ourMovie;                          // variable to hold the video
void setup() {
  size(480, 360);
  ourMovie = new Movie(this, "scream.mp4"); 
  ourMovie.loop();
}

void draw() {
  int x = (int) random ( 0, width);  // randomizing 4 numbers for the rects
  int y = (int)random ( 0, width);
  int w =(int)random ( 50, 200);
  int h =(int)random ( 50, 200);
  // every second changing the blend mode to somethng else
  if (second() %4 ==0) blend(ourMovie, x, y, w, h, x, y, w, h, DARKEST);
  else if (second() %4 ==1) blend(ourMovie, x, y, w, h, x, y, w, h, LIGHTEST);
  else if (second() %4 ==2) blend(ourMovie, x, y, w, h, x, y, w, h, DIFFERENCE);
  else if (second() %4 ==3) blend(ourMovie, x, y, w, h, x, y, w, h, SUBTRACT);
}

void movieEvent(Movie m) {              //  callback function that reads a frame whenever its ready
  m.read();
}
