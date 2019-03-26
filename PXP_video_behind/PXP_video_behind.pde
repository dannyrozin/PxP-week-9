// The world pixel by pixel 2019
// Daniel Rozin
// uses PXP methods in the bottom
// does a chroma key effect but on an image so the live video appears behind, click the mouse to select a key color, move the mouse to change the threshold

import processing.video.*;
PImage secondImage;
float keyR=0, keyG=255, keyB=0;
Capture video;
int threshold = 200;
void setup() {
  size(640, 480);                                                  
  video = new Capture(this, width, height, 30);
  video.start();

  secondImage = loadImage("bartTV.png");
  secondImage.resize(width, height);
  fill(keyR, keyG, keyB);
}

void draw() {
  if (video.available()) video.read();
  image(video, 0, 0);                                                 // draw the whole live video frame on the screen
  loadPixels();                                                           // load the screen pixels                                                 
  video.loadPixels();                                                   // load the video pixels     
  secondImage.loadPixels();                                                   // load the image pixels     
  threshold = mouseX;                                                     // moving the mouse changes the threshold
  for (int y = 0; y < video.height; y++) {
    for (int x = 0; x < video.width; x++) {                                                                                               
      PxPGetPixel(x, y, secondImage.pixels, width);               // get the RGB of the image (Bart)
      float distance = dist(R, G, B, keyR, keyG, keyB);           // compare our pixel to the target,R,G,B
      if (distance > threshold) {   
                                                                         // If that distance is greater than the threshold then place 
        PxPSetPixel(x, y, R, G, B, 255, pixels, width);                 // that pixel (bart) on the screen (on top of live video)
      }
    }
  } 
  updatePixels();  
  rect(10, 10, 20, 20);                                           // draw a little square with the key color
}

void mousePressed() {
  PxPGetPixel(mouseX, mouseY, secondImage.pixels, width);               // get the RGB of the image (bart) under the mouse
  keyR= R;                                                        // set the key color to the color under the mouse
  keyG= G;
  keyB= B;
  fill(keyR, keyG, keyB);
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
