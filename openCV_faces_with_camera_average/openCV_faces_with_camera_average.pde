
// The world pixel by pixel 2019
// Daniel Rozin
// tracks faces with opencv and averages all faces it sees in a ghost effect
// uses PXP methods in the bottom
// download openCV for procesing: sketch->inport library->Add library...

import gab.opencv.*;
import processing.video.*;
import java.awt.*;

Capture video;
OpenCV opencv;
float[][][] floatPixels = new float[640][480][3];  
float transparancy= 0.99;
void setup() {
  size(640, 480);
  video = new Capture(this, 640, 480);
  opencv = new OpenCV(this, 640, 480);
  opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
  video.start();
}

void draw() {

  opencv.loadImage(video);                     // takes the live video as the source for openCV
  image(video, 0, 0 );                         // show the live video , in case no faces will be found

  Rectangle[] faces = opencv.detect();         // track the faces and put the results in array

  loadPixels() ;                           
  video.loadPixels();
  for (int i = 0; i < faces.length; i++) {       // well do it to all faces found , if no faces found then will be skipped and rthe fideo will show
    float XRatio= (faces[i].width/float(width));    // calculate the ratio between the full window and this face rect
    float YRatio= (faces[i].height/float(height));
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        PxPGetPixel(int(faces[i].x+ XRatio*x), int(faces[i].y+ YRatio*y), video.pixels, width);
        floatPixels[x][y][0]= floatPixels[x][y][0]* transparancy + R* (1-transparancy);                  //  multiply the stored array value by transparency 
        floatPixels[x][y][1]= floatPixels[x][y][1]* transparancy + G* (1-transparancy);                  // and the current video with opacity (1- transparency)
        floatPixels[x][y][2]= floatPixels[x][y][2]* transparancy + B* (1-transparancy);
        int newR=   (int)floatPixels[x][y][0];                                                           // get an int representation of the array
        int newG=   (int)floatPixels[x][y][1];
        int newB=   (int)floatPixels[x][y][2];
        PxPSetPixel(x, y, newR, newG, newB, 255, pixels, width);
      }
    }
  }
  updatePixels();
  text("found "+faces.length+" faces",10,10);
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
