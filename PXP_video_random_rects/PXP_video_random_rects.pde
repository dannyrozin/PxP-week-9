// The world pixel by pixel 2020
// Daniel Rozin
// places random rects of video on screen, no interaction
import processing.video.*;
Movie ourMovie;                          // variable to hold the video
void setup() {
  size(480, 360);
  ourMovie = new Movie(this, "scream.mp4"); 
  ourMovie.loop();
}

void draw() {
  int x = (int) random ( 0, width);
  int y = (int)random ( 0, width);
  int w =(int)random ( 50, 200);
  int h =(int)random ( 50, 200);
  copy(ourMovie, x, y, w, h, x, y, w, h);
}

void movieEvent(Movie m) {              //  callback function that reads a frame whenever its ready
  m.read();
}
