// The world pixel by pixel 2022
// Daniel Rozin
// copying movie with transparancy to create ghosting effect

import processing.video.*;
float[][][] floatPixels = new float[480][360][3];                       // an array of floats to hold our image in higher color depth resolution (32 bits per channel)
float transparancy= 0.999;
int R, G, B, A;          // you must have these global varables to use the PxPGetPixel()
Movie ourVideo;          // variable to hold the video

void setup() {
  size(480, 360);
  ourVideo = new Movie(this, "powers of ten.mp4");       // open default video in the size of window
  ourVideo.loop();                                  // start the video
}

void draw() {
  if (ourVideo.available()) {
    ourVideo.read();
    ourVideo.loadPixels();
    loadPixels();
    transparancy= map(mouseX, 0, width, 0.9, 1);
    for (int x = 0; x< width; x++) {
      for (int y = 0; y< height; y++) {
        PxPGetPixel(x, y, ourVideo.pixels, width);                 // get the RGB of our pixel
        floatPixels[x][y][0]= floatPixels[x][y][0]* transparancy + R* (1-transparancy);                  //  multiply the stored array value by transparency
        floatPixels[x][y][1]= floatPixels[x][y][1]* transparancy + G* (1-transparancy);                  // and the current video with opacity (1- transparency)
        floatPixels[x][y][2]= floatPixels[x][y][2]* transparancy + B* (1-transparancy);
        int newR=   (int)floatPixels[x][y][0];                                                           // get an int representation of the array
        int newG=   (int)floatPixels[x][y][1];
        int newB=   (int)floatPixels[x][y][2];
        PxPSetPixel(x, y, newR, newG, newB, 255, pixels, width);                                        // sets the R,G,B values to the window
      }
    }
    updatePixels();
  }
}








// our function for getting color components , it requires that you have global variables
// R,G,B   (not elegant but the simples way to go, see the example PxP methods in object for
// a more elegant solution)

void PxPGetPixel(int x, int y, int[] pixelArray, int pixelsWidth) {
  int thisPixel=pixelArray[x+y*pixelsWidth];     // getting the colors as an int from the pixels[]
  A = (thisPixel >> 24) & 0xFF;                  // we need to shift and mask to get each component alone
  R = (thisPixel >> 16) & 0xFF;                  // this is faster than calling red(), green() , blue()
  G = (thisPixel >> 8) & 0xFF;
  B = thisPixel & 0xFF;
}


//our function for setting color components RGB into the pixels[] , we need to define the XY of where
// to set the pixel, the RGB values we want and the pixels[] array we want to use and it's width

void PxPSetPixel(int x, int y, int r, int g, int b, int a, int[] pixelArray, int pixelsWidth) {
  a =(a << 24);
  r = r << 16;                       // We are packing all 4 composents into one int
  g = g << 8;                        // so we need to shift them to their places
  color argb = a | r | g | b;        // binary "or" operation adds them all into one int
  pixelArray[x+y*pixelsWidth]= argb;    // finaly we set the int with te colors into the pixels[]
}
