// The world pixel by pixel 2022
// Daniel Rozin
// uses PXP methods in the bottom
// tracks change, click the mouse to create a reference frame, move the mouse to change the threshold

import processing.video.*;
PImage frameToCompare;
Capture video;
int threshold = 300;
void setup() {
  size(720, 480);                                                   // Change size to 320 x 240 if too slow at 640 x 480
  String videoList[] = Capture.list();
  video = new Capture(this, width, height, videoList[0]);
  video.start();
  frameToCompare = new PImage(width,height);                          // here we will store 1 frame of video to compare with the live frame
  noFill();   
  strokeWeight(2);
  frameRate(30);
}

void draw() {
  if (video.available())     video.read();
    image(video, 0, 0, width, height);                      // Draw the  video onto the screen
    video.filter(BLUR,1);                                   // adding a blur makes itb less jumpy
    int leftMost = width+10;                                   // we want to draw a rect around all area of change so                                                      
    int topMost = height +10;                                  // we need to look for the most left, top, right and bottom
    int rightMost = -10;                                        // we start with values that are outside of frame, in case we dont finf anything
    int bottomMost = -10;
    video.loadPixels();
    frameToCompare.loadPixels();
     threshold = mouseX;     
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {                                                                                               
        PxPGetPixel(x, y, video.pixels, width);               // get the RGB of the live video
      int videoR=R;
      int videoG= G;
      int videoB= B;
      PxPGetPixel(x, y, frameToCompare.pixels, width);           // get the RGB of the stored frame
      float distance = dist(R, G, B, videoR, videoG, videoB);    // compare our live pixel to the stored frame pixel's RGB
        if (distance > threshold) {                              // If that distance is smaller than the threshold, then check
          if (x< leftMost)leftMost = x;                          // if the pixel is within the rectangle of the leftMost,topMost etc. 
          if (x> rightMost)rightMost = x;                        // and if it isn't then increase the rectangle to contain
          if (y< topMost)topMost = y;
          if (y> bottomMost)bottomMost = y;
        }
      }
    }   
    rectMode(CORNERS);
    rect(leftMost, topMost, rightMost,bottomMost);               // draw the rectangle that contains all the pixels that are different from reference
  // frameToCompare.set(0,0,video);                             // add this to track movement instead of change
  }


void mousePressed() {                                            // click mouse to copy the video into the reference frame  
  frameToCompare.set(0,0,video);                                                                   
}




// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for 
// a more elegant solution
int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;   
  B = thisPixel & 0xFF;
}


//our function for setting color components RGB into the pixels[] , we need to efine the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);                       
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}
