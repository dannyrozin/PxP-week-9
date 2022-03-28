// The world pixel by pixel 2022
// Daniel Rozin
// ghosting frames of a video, move mouse to change transparency
import processing.video.*;
Movie ourMovie;                          // variable to hold the video
void setup() {
  size(480, 360);
  ourMovie = new Movie(this, "bulletproof.mp4");
  ourMovie.loop();                          // start playing the video and loop
}

void draw() {
  if (ourMovie.available()) {
    ourMovie.read();
    float transparency = map (mouseX, 0, width, 0, 20);
    tint (255, transparency);
    image(ourMovie, 0, 0);
  }
}
