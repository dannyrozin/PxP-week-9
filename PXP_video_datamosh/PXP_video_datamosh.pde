// The world pixel by pixel 2020
// Daniel Rozin
// uses PXP methods in the bottom
// does a datamosh effect,  move the mouse to change the threshold

import processing.video.*;
PImage frameToCompare;
Movie ourMovie;        
int threshold = 200;
void setup() {
  println(Capture.list());
  size(480, 360);                                                   
  ourMovie = new Movie(this, "virtual.mp4"); 
  ourMovie.loop();
  frameToCompare = new PImage(width, height);                 // here we will store 1 frame of video to compare with the live frame
  noFill();   
  strokeWeight(2);
  rectMode(CORNERS);
  fill(255, 255, 0);
  frameRate(30);
}

void draw() {
  int countChangePixels= 0;                                  // we count the pixels that have changed to make a yellow bar
  threshold = mouseX; 
  loadPixels();                                                              
  ourMovie.loadPixels();
  frameToCompare.loadPixels();                              // we need all these pixels: video, stored frame and screen
  for (int y = 0; y < ourMovie.height; y++) {
    for (int x = 0; x < ourMovie.width; x++) {                                                                                               
      PxPGetPixel(x, y, ourMovie.pixels, width);               // get the RGB of the live video
      int videoR=R;
      int videoG= G;
      int videoB= B;
      PxPGetPixel(x, y, frameToCompare.pixels, width);      // get the RGB of the stored frame
      float distance = dist(R, G, B, videoR, videoG, videoB);   // compare our live pixel to the stored frame pixel's RGB
      if (distance > threshold) {                                                         // If that distance is greater than the threshold, then 
        PxPSetPixel(x, y, videoR, videoG, videoB, 255, pixels, width);                    // put that pixel on the screen 
        countChangePixels++;                                                               // keep tabs of how many change pixels we find
      }
    }
  } 
  updatePixels();  

  
  frameToCompare.copy(ourMovie, 0, 0, width, height, 0, 0, width, height);                  // add this to track movement instead of change
}




void movieEvent(Movie m) {              //  callback function that reads a frame whenever its ready
  m.read();
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
