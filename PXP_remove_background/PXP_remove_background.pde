// The world pixel by pixel 2019
// Daniel Rozin
// uses PXP methods in the bottom
// removes the background and uses as key, click the mouse to select the background, move the mouse to change the threshold

import processing.video.*;
PImage frameToCompare;
PImage secondImage;
Capture video;
int threshold = 200;
void setup() {
  size(640, 480);                                                  
  video = new Capture(this, width, height, 30);
  video.start();
  frameToCompare = new PImage(width,height);     // this will hold our background image
  secondImage = loadImage("eiffel.jpg");
  secondImage.resize(width, height);
  noFill();   
  strokeWeight(2);
}

void draw() {

  if (video.available()) video.read();
    image(video,0,0);
     video.filter(BLUR,1);                                                 // makes the video less jumpy if blurred a bit
    loadPixels();                                                           // load the screen pixels                                                 
    video.loadPixels();                                                   
    frameToCompare.loadPixels();                                             // load the reference frame pixels
      threshold = mouseX;  
    for (int y = 0; y < video.height; y++) {
      for (int x = 0; x < video.width; x++) {                                                                                               
        PxPGetPixel(x, y, video.pixels, width);               // get the RGB of the live video
      int videoR=R;
      int videoG= G;
      int videoB= B;
      PxPGetPixel(x, y, frameToCompare.pixels, width);      // get the RGB of the stored frame
      float distance = dist(R, G, B, videoR, videoG, videoB);   // compare our live pixel to the stored frame pixel's RGB
      if (distance < threshold) {   
        PxPGetPixel(x, y, secondImage.pixels, width);                            // If that distance is greater than the threshold then place 
           PxPSetPixel(x, y, R, G, B, 255, pixels, width);                 // that pixel on the screen
        }
      }
    } 
    updatePixels();  
    if (mousePressed ==true){                                                                    // click mouse to copy the video into the reference frame
      frameToCompare.copy(video,0,0,width,height,0,0,width,height);
    }
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
