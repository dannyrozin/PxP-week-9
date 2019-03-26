
// The world pixel by pixel 2019
// Daniel Rozin
// tracks faces with opencv and enlarges the face to fill the whole window
// uses PXP methods in the bottom
// download openCV for procesing: sketch->inport library->Add library...

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;

void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
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






// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution

void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}

int A, R, G, B;
//our function for setting color components RGB into the pixels[] , we need to efine the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}
