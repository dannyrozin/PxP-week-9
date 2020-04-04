// The world pixel by pixel 2020
// Daniel Rozin
// ghosting frames of a video, move mouse to change transparency
import processing.video.*;
Movie ourMovie;                          // variable to hold the video
void setup() {
  size(480, 360);
  ourMovie = new Movie(this, "scream.mp4"); 
  ourMovie.loop();                          // start playing the video and loop
}

void draw() {
  float transparency = map (mouseX, 0,width,0,10);
  tint (255,transparency);
  image(ourMovie,0,0);                         
}

void movieEvent(Movie m) {              //  callback function that reads a frame whenever its ready
  m.read();
}
