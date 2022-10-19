class Grid {
  //Variables
  PImage image;
  PImage resize;

  int windowW;
  int windowH;
  int w;
  int h;

  int resizeW;
  int resizeH;
  int borderSize = 20;
  int step;

  float gridMaxOffset;
  int offsetMode;
  final int VER = 0;
  final int HOR = 1;

  FloatList posX = new FloatList();
  FloatList posY = new FloatList();
  FloatList sizes = new FloatList();

  float gridOffset;
  int gridSize = 40;
  float contrast;
  int midCont;
  int minBri;
  int maxBri;
  float[][] tracker = new float[6][2];

  float gridW;
  float gridH;
  
  //Constructor
  Grid(int i) {
    loadImageGrid(i);
    setImage();
  }
  
  //Load the image to analyse
  void loadImageGrid(int i) {
    image = loadImage("images/" + fileNames[i]);
  }

  //Creates a grid of dots from the image
  void update(float go, int gs, float con, int mc, int minB, int maxB) {
    //Sets of the global variables
    gridOffset = go;
    gridSize = gs;
    contrast = con;
    gridMaxOffset = (min(resize.width, resize.height) * step) - min(windowW, windowH);
    midCont = mc;
    minBri = minB;
    maxBri = maxB;
    setImage();
    
    //Empties the position an sizes arrays
    posX.clear();
    posY.clear();
    sizes.clear();

    //Draw the grid of dots
    resize.loadPixels();
    noStroke();
    for (int y = 0; y < resize.height; y++) {
      for (int x = 0; x < resize.width; x++) {
        
        //If a pixel is outside the boundaries, don't draw it
        if (offsetMode == HOR) {
          if (x*step >= windowW - borderSize/2 || x*step <= borderSize/2 
            || y*step - (gridMaxOffset * (gridOffset/100)) >= windowH - borderSize/2 || y*step - (gridMaxOffset * (gridOffset/100)) <= borderSize/2) {
            continue;
          }
        } else {
          if (x*step - (gridMaxOffset * (gridOffset/100)) >= windowW - borderSize/2 || x*step - (gridMaxOffset * (gridOffset/100)) <= borderSize/2 
            || y*step >= windowH - borderSize/2 || y*step <= borderSize/2) {
            continue;
          }
        }
        
        //Puts the x, y, and sizes values in the arrays.
        int index = x + (y*resize.width);
        float size = constrain(map(contrast(brightness(resize.pixels[index]), contrast), minBri, maxBri, 0, step), 0, step);
        fill(255);
        if (offsetMode == HOR) {
          posX.append(x*step + (borderSize/2));
          posY.append(y*step + (borderSize/2) - (gridMaxOffset * (gridOffset/100)));
        } else {
          posX.append(x*step + (borderSize/2) - (gridMaxOffset * (gridOffset/100)));
          posY.append(y*step + (borderSize/2));
        }
        if (size > 0) {
          size += 1;
        }
        sizes.append(size);
      }
    }
    //Calculates the width and height of the grid
    gridW = posX.get(posX.size() - 1) - posX.get(0);
    gridH = posY.get(posY.size() - 1) - posY.get(0);
  }

  //Changes the contrast level of the pixels
  float contrast(float col, float perc) {
    int target;
    if (col < midCont) {
      target = 0;
    } else {
      target = 255;
    }

    return lerp(col, target, perc);
  }
  
  //Sets the boundaries where to draw the points
  void setWindowSize(int _w, int _h) {
    w = _w;
    h = _h;
  }

  //Resizes the image to analyse
  void setImage() {
    if (image.width <= image.height) {
      resizeW = gridSize;
      resizeH = gridSize * image.height / image.width;
      offsetMode = VER;
    } else {
      resizeH = gridSize;
      resizeW = gridSize * image.width / image.height;
      offsetMode = HOR;
    }

    resize = createImage(resizeW, resizeH, RGB);
    resize.copy(image, 0, 0, image.width, image.height, 0, 0, resize.width, resize.height);

    windowW = w - borderSize;
    windowH = h - borderSize;

    step = int(max(windowW, windowH) / min(resize.width, resize.height));
  }
}
