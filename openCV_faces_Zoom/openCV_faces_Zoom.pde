// The world pixel by pixel 2020
// Daniel Rozin
// find faces with opencv in a png, in this case a Zoom caprure
// download openCV for procesing: sketch->inport library->Add library...

import gab.opencv.*;
import java.awt.Rectangle;

OpenCV opencv;
Rectangle[] faces;

void setup() {
  opencv = new OpenCV(this, "zoom.png");
  size(1280, 720);

  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  faces = opencv.detect();
}

void draw() {
  image(opencv.getInput(), 0, 0);
  noFill();
  stroke(0, 255, 0);
  strokeWeight(3);
  for (int i = 0; i < faces.length; i++) {
    rect(faces[i].x, faces[i].y, faces[i].width, faces[i].height);
  }
}
