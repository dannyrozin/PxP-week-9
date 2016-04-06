// The world pixel by pixel 2016
// Daniel Rozin
// track multiple colors in video
// uses PXP methods in the bottom
import processing.video.*;

Capture ourVideo;          // variable to hold the video
targetColor[] targets=new targetColor [0];           // array to hold objects of type targetColors

void setup() {
  size(1280, 720);
  frameRate(120);
  ourVideo = new Capture(this, width, height);       // open default video in the size of window
  ourVideo.start();                                  // start the video
}

void draw() {
  image(ourVideo, 0, 0);
  if (ourVideo.available())  ourVideo.read();       // get a fresh frame of video as often as we can
  ourVideo.loadPixels();                            // load the pixels array of the video 
  for (int i = 0; i< targets.length; i++) {
    targets[i].record= 1000;
  }
  int recordHolderX=0, recordHolderY=0;             //these wil hold the location of the record holder
  float record= 1000;                                    //this will hold the best value weve seen so far

  for (int x = 0; x<width; x++) {
    for (int y = 0; y<height; y++) {
      PxPGetPixel(x, y, ourVideo.pixels, width);    // Get the RGB of each pixel
      for (int i = 0; i< targets.length; i++) {

        float thisPixelSimilarity= dist(targets[i].red, targets[i].green, targets[i].blue, R, G, B);     // dist calculates how similar the colors are
        if (thisPixelSimilarity <targets[i].record) {                 // if our pixel is better than the record
          targets[i].record= thisPixelSimilarity;                     //we remember the new record
          targets[i].recordHolderX= x;                                // and the new record holdeo
          targets[i].recordHolderY= y;
        }
      }
    }
  }
  for (int i = 0; i< targets.length; i++) {
    fill(targets[i].red, targets[i].green, targets[i].blue);
    ellipse( targets[i].recordHolderX, targets[i].recordHolderY, 10, 10);        // when we are done with all pixels the the best pixel is recordHolder
  }
}

void mousePressed() {
  PxPGetPixel(mouseX, mouseY, ourVideo.pixels, width);    // Get the RGB of pixel under the mouse
  targets= (targetColor[]) append(targets, new targetColor(R, G, B));                                              // set the RGB under the mouse to the target
}

class targetColor {                                       // 

  int red, green, blue;
  float record=1000;
  int recordHolderX=0;
  int recordHolderY= 0;
  targetColor(int r, int g, int b) {
    red= r;
    green= g;
    blue= b;
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