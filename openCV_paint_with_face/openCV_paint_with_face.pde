
// The world pixel by pixel 2020
// Daniel Rozin
// tracks faces with opencv and lets you paint by moving face
// download openCV for procesing: sketch->inport library->Add library...

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

void setup() {
  size(640, 480);
  String videoList[] = Capture.list();
  video = new Capture(this, 320, 240, videoList[0]);                  // make small to make it faster
  opencv = new OpenCV(this, 320, 240);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
  fill(255, 0, 0, 100);
  noStroke();
}

void draw() {
  opencv.loadImage(video);                     // takes the live video as the source for openCV
  image(video, 0, 0, 64, 48 );                         // show the live video
  Rectangle[] faces = opencv.detect();         // track the faces and put the results in array
  if ( faces.length>0) {                       // we will do this for first face 
    ellipse(width-(faces[0].x+faces[0].width/2)*2, (faces[0].y+faces[0].height/2)*2, 20, 20) ;   
    // draw a circle in the location of the center of the face 
    // we multiply by 2 because we are capturing in half size
    // we subtract from width to flip the effect horizontaly
  }
}                                                                                              
void captureEvent(Capture c) {
  c.read();
}
