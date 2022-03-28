// The world pixel by pixel 2022
// Daniel Rozin
// scratch video, drag mouse to change frame
import processing.video.*;
Movie ourMovie;                          // variable to hold the video
void setup() {
  size(480, 360);
  ourMovie = new Movie(this, "scream.mp4"); 
  ourMovie.loop();
}

void mouseDragged() {
  float positon = map (mouseX, 0, width, 0, ourMovie.duration());
  ourMovie.play();
  ourMovie.jump(positon);

}

void draw() {              //  callback function that reads a frame whenever its ready
  if (ourMovie.available()) ourMovie.read();
   image(ourMovie, 0, 0);   
}
