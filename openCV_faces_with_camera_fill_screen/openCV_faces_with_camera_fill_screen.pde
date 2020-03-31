
// The world pixel by pixel 2020
// Daniel Rozin
// tracks faces with opencv and enlarges the face to fill the whole window
// download openCV for procesing: sketch->inport library->Add library...

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

void setup() {
  size(640, 480);
  String videoList[] = Capture.list();
  video = new Capture(this, width, height, videoList[0]);
  opencv = new OpenCV(this, width, height);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
}

void draw() {
  opencv.loadImage(video);                     // takes the live video as the source for openCV
  image(video, 0, 0 );                         // show the live video , in case no faces found
  Rectangle[] faces = opencv.detect();         // track the faces and put the results in array
  if ( faces.length>0) {                       // we will do this for first face 
     copy(video, 
     faces[0].x, faces[0].y, faces[0].width, faces[0].height,        // copy from the rect of the face 
     0,0,width,height);                                              // to the full screen    
  }
}

void captureEvent(Capture c) {
  c.read();
}
