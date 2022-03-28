
// The world pixel by pixel 2022
// Daniel Rozin
// tracks faces with opencv and counts how many faces
// download openCV for procesing: sketch->inport library->Add library...

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

PImage  one, two, many;          // will hold the images

void setup() {
  size(1024, 768);               // bigger is better but slower
  String videoList[] = Capture.list();
  video = new Capture(this, width, height, videoList[0]);  //open the camera                // make small to make it faster
  opencv = new OpenCV(this, width, height);               // open openCV
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);         // file has to be in data folder
  video.start();
  fill(255, 0, 0, 100);
  noStroke();
  textSize( 30);
  one= loadImage("one.png");             // load the images int PImages
  two= loadImage("two.png");
  many= loadImage("many.png");
  imageMode(CENTER);
}

void draw() {
  background(255);
  if ( video.available() )video.read();
  opencv.loadImage(video);                     // takes the live video as the source for openCV
  image(video, 32, 24, 64, 48 );                 // show the live video
  Rectangle[] faces = opencv.detect();         // track the faces and put the results in array
  print("number of faces found: ");
  println(faces.length);                      // the number of entries in the array are the number of faces
  switch(faces.length) {                      
  case 0:                                     // if you see no one
    text ("Where's Everyone?", 200, 200);
    break;
  case 1:                                    // if you see one
    image(one, width/2, height/2, 300, 300);
    break;
  case 2:                                    // if you see two
    image(two, width/2, height/2, 300, 300);
    break;
  default:                                  // if its not zero,one, two then its many...
    image(many, width/2, height/2, width, height);
    break;
  }
}
