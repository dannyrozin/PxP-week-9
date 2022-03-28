// The world pixel by pixel 2022
// Daniel Rozin
// move mouse x to change speed
import processing.video.*;
Movie ourMovie;                          // variable to hold the video
void setup() {
  size(480, 360);
  ourMovie = new Movie(this, "scream.mp4"); 
  ourMovie.loop();
}

void draw() {              //  callback function that reads a frame whenever its ready
  float speed = map (mouseX, 0, width, 0.1, 10);
  ourMovie.speed(speed) ;
  if (ourMovie.available()) ourMovie.read();
   image(ourMovie, 0, 0);   
}
