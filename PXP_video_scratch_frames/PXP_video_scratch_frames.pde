// The world pixel by pixel 2021
// Daniel Rozin
// scratch video, move mouse to change frame
import processing.video.*;
Movie ourMovie;                          // variable to hold the video
void setup() {
  size(480, 360);
  ourMovie = new Movie(this, "scream.mp4"); 
}

void draw() {
  float positon = map (mouseX, 0, width, 0, ourMovie.duration());
  image(ourMovie, 0, 0);   
  ourMovie.play();
  ourMovie.jump(positon);
  ourMovie.pause();

}

void movieEvent(Movie m) {              //  callback function that reads a frame whenever its ready
  m.read();
}
