/*
 * Class: EDM4611-020
 * Title: Projet 1 - Système générateur
 * Autor: Samuel Favreau
 
 * Instructions: Select an image from the images folder and use the sliders to create plans for a laser cutting machine.
 */

//Librairies
//Hemesh
import wblut.processing.*;
import wblut.hemesh.*;
import wblut.geom.*;
import wblut.math.*;
import java.util.List;
//ControlP5
import controlP5.*;
//SVG
import processing.svg.*;

//Variables
//Hemesh
WB_Render3D render;
ArrayList<Wall> walls = new ArrayList();
ArrayList<Grid> grids = new ArrayList();

//ControlP5
ArrayList<ControlP5> cp5 = new ArrayList();
boolean showCP5 = true;
boolean CP5Enable = false;

//Slider variables
float gridOffset0, gridOffset1, gridOffset2, gridOffset3, gridOffset4;
int gridSize0, gridSize1, gridSize2, gridSize3, gridSize4; //50
float contrast0, contrast1, contrast2, contrast3, contrast4;
int midCont0, midCont1, midCont2, midCont3, midCont4; //128
int minBri0, minBri1, minBri2, minBri3, minBri4;
int maxBri0, maxBri1, maxBri2, maxBri3, maxBri4; //255
float[][] options = new float[6][5];
int[] imgID = new int[5];

//Plan variables
int editedWall;
int[] editedWallTrack = new int[2];
float t;

//File name variables
String[] fileNames;
int dropDownID;

//SVG
boolean record = false;
PGraphics wallRender;
PGraphics output;
PImage preview;

//Render variables
int wallNb = 1;
float[] wallTrack = new float[2];
boolean exportInterface = true;
float rotX = 0;
float rotY = 0;
float zoom = 0;
int lightHue = 0;
int lightSat = 100;
int lightBri = 100;

boolean rendering = false;
boolean[] renderTrack = new boolean[2];

final boolean pierced = true;
final boolean engraved = false;
boolean mode;

//------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------- SETUP -------------------------------------------------
//------------------------------------------------------------------------------------------------------------------

void setup() {
  size(1000, 1000, P3D);
  smooth(8);

  colorMode(HSB, 360, 100, 100);

  gridSize0 = gridSize1 = gridSize2 = gridSize3 = gridSize4 = 50;
  midCont0 = midCont1 = midCont2 = midCont3 = midCont4 = 128;
  maxBri0 = maxBri1 = maxBri2 = maxBri3 = maxBri4 = 255;

  //Gets all the names of the images from the data folder and puts them in an array
  java.io.File dataFolder = new java.io.File(dataPath("images"));
  fileNames = dataFolder.list();

  cp5.add(new ControlP5(this));

  //General sliders
  cp5.get(0).addSlider("wallNb")
    .setPosition(500, 30)
    .setRange(1, 5)
    .setLabel("Number of walls")
    ;

  cp5.get(0).addButton("<")
    .setValue(0)
    .setPosition(500, 45)
    .setSize(20, 20)
    ;

  cp5.get(0).addButton(">")
    .setValue(0)
    .setPosition(550, 45)
    .setSize(20, 20)
    ;

  cp5.get(0).addScrollableList("dropdown")
    .setPosition(700, 30)
    .addItems(fileNames)
    ;

  cp5.get(0).addButton("save")
    .setValue(0)
    .setPosition(840, 30)
    .setSize(50, 20)
    ;

  cp5.get(0).addButton("render")
    .setValue(0)
    .setPosition(840, 60)
    .setSize(50, 20)
    ;

  cp5.get(0).addToggle("mode")
    .setPosition(100, 90)
    .setSize(100, 20)
    .setValue(true)
    .setMode(ControlP5.SWITCH)
    .setLabel("Pierced             Engraved")
    ;

  //Individual sliders
  for (int i = 1; i < 6; i++) {
    //Sets the slider modifier;
    cp5.add(new ControlP5(this));

    cp5.get(i).addSlider("gridOffset" + str(i - 1))
      .setPosition(100, 30)
      .setRange(0, 100)
      .setLabel("Grid Offset")
      ;

    cp5.get(i).addSlider("gridSize" + str(i - 1))
      .setPosition(100, 50)
      .setRange(30, 80)
      .setLabel("Grid Size")
      ;

    cp5.get(i).addSlider("contrast" + str(i - 1))
      .setPosition(100, 70)
      .setRange(0, 1)
      .setLabel("Contrast")
      ;

    cp5.get(i).addSlider("minBri" + str(i - 1))
      .setPosition(300, 30)
      .setRange(0, 254)
      .setLabel("Min Brightness")
      ;

    cp5.get(i).addSlider("maxBri" + str(i - 1))
      .setPosition(300, 50)
      .setRange(1, 255)
      .setLabel("Max Brightness")
      ;

    cp5.get(i).addSlider("midCont" + str(i - 1))
      .setPosition(300, 70)
      .setRange(0, 255)
      .setLabel("Contrast point")
      ;

    cp5.get(i).hide();
  }

  cp5.add(new ControlP5(this));

  cp5.get(cp5.size() - 1).addButton("back")
    .setValue(0)
    .setPosition(840, 60)
    .setSize(50, 20)
    ;

  cp5.get(cp5.size() - 1).addSlider("lightHue")
    .setPosition(840, 30)
    .setRange(1, 360)
    .setLabel("Light color")
    ;

  cp5.get(cp5.size() - 1).hide();

  //Sets the rendering of the 3d shapes
  render=new WB_Render3D(this);
}

//------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------- DRAW --------------------------------------------------
//------------------------------------------------------------------------------------------------------------------

void draw() {
  background(55);
  //Set the value of all the individual sliders
  setOptions();

  //If the number of wall has changed
  if (detectChange(wallNb, wallTrack)) {
    //Reset the wall the grid and the render
    walls = new ArrayList();
    grids = new ArrayList();
    wallRender = createGraphics(510*wallNb, 800);
    preview = createImage(wallRender.width * 200 / (wallRender.height - 150), 200, RGB);

    //Adds the new values to the walls
    for (int i = 0; i < wallNb; i++) {
      walls.add(new Wall());
      grids.add(new Grid(imgID[i]));

      grids.get(i).setWindowSize(400, 600);
      grids.get(i).update(options[0][i], int(options[1][i]), options[2][i], int(options[3][i]), int(options[4][i]), int(options[5][i]));

      walls.get(i).grid = grids.get(i);
    }
  }

  //Update the grid with the value of the slider
  for (int i = 0; i < wallNb; i++) {
    grids.get(i).update(options[0][i], int(options[1][i]), options[2][i], int(options[3][i]), int(options[4][i]), int(options[5][i]));
  }

  //If the render mode is on
  if (!exportInterface) {
    //Rotates the shape from the mouse movement
    if (!(mouseX > 840 && mouseX < 1000 && mouseY < 100)) {
      if (mousePressed) {
        rotY += (mouseX - pmouseX);
        rotX -= (mouseY - pmouseY);
      }
    }


    push();
    //Light sources
    directionalLight(lightHue, 10, lightBri, 1, 1, -1);
    pointLight(lightHue, lightSat, lightBri, width/2, height/2, zoom);
    //Manages the position and the zoom
    translate(width/2, height/2, zoom);
    //Sets the rotation
    rotateY(radians(rotY));
    rotateX(radians(rotX));
    
    //Light bulb
    push();
    translate(0, 250);
    rotateX(HALF_PI);
    emissive(lightHue, lightSat, lightBri);
    specular(255, 255, 255);
    shininess(1.0);
    sphere(50);
    pop();

    //Render the 3D shapes of the wall
    noStroke();
    for (int i = 0; i < wallNb; i++) {
      push();
      rotateY(i * (TWO_PI/wallNb));
      float distance = constrain(map(wallNb, 3, 5, 120, 300), 120, 300);
      translate(0, 0, distance);

      color face = 0;
      color sides = 0;
      
      //Makes a wooden or acrylic texture depending on the mode
      if (mode == engraved) {
        face = color(lightHue, 100, 100, 50);
        sides = color(lightHue, 100, 100, 50);
      } else if (mode == pierced){
        face = #F5DC88;
        sides = #503529;
      }

      //Render plane faces
      fill(face);
      render.drawFacesWithInternalLabel(1, walls.get(i).mesh);
      push();
      translate(0, 0, -10);
      if(mode == pierced)
      render.drawFacesWithInternalLabel(1, walls.get(i).mesh);
      else if (mode == engraved)
      render.drawFacesWithInternalLabel(1, walls.get(i).meshA);
      pop();
      //Render extruded faces
      fill(sides);
      if(mode == pierced)
      render.drawFacesWithInternalLabel(2, walls.get(i).mesh);
      else if (mode == engraved)
      render.drawFacesWithInternalLabel(2, walls.get(i).meshA);

      //Draw engraving insted of holes
      if (mode == engraved) {
        push();
        translate(0, 0, 10);
        imageMode(CORNERS);
        image(walls.get(i).wall, walls.get(i).topCorner.x, walls.get(i).topCorner.y, walls.get(i).bottomCorner.x, walls.get(i).bottomCorner.y);
        pop();
      }

      //Draw a translucent pannel behind the walls
      if (mode == pierced) {
        push();
        fill(lightHue, 10, 100, 100);
        rectMode(CENTER);
        translate(0, 0, -10);
        rect(0, 0, 400, 600);
        pop();
      }

      pop();
    }
    pop();
  } 
  //If the export mode is on
  else {
    //Preview plans
    fill(0, 0, 100); //red
    noStroke();
    rect(0, 0, width, height);

    //If the record mode is on
    if (record) {
      //Render a PGraphics as SVG
      String date = str(year()) + "-" + str(month()) + "-" + str(day()) + "-" + str(hour()) + "-" + str(minute())+ "-" + str(second());
      output = createGraphics(wallRender.width, wallRender.height, SVG, "data/output/output-" + date +".svg");
      drawGraphics(output);
      record = false;
    }


    //Draws the main plan
    drawGraphics(wallRender);
    preview.copy(wallRender, 0, 150, wallRender.width, wallRender.height, 0, 0, preview.width, preview.height);

    //The timer increses if it's lower then 1
    if (t < 1) {
      t+=0.1;
    }
    //Centers the plan on the current wall
    float renderPos = lerp(-460 * (editedWallTrack[0] - 1), -460 * (editedWallTrack[1] - 1), t);

    imageMode(CORNER);
    image(wallRender, 230 + renderPos, 0);
    imageMode(CENTER);
    image(preview, width/2, height - 120);
  }

  //Shows the slider of the current wall
  currentSlider();

  //Show interface
  if (showCP5) {
    noStroke();
    fill(200);
    rect(0, 0, width, 130);
    fill(0, 0, 100);
    text("Selected Wall", 600, 60);
    text(str(editedWall), 530, 60);
  }

  CP5Enable = true;
}

//------------------------------------------------------------------------------------------------------------------
//---------------------------------------------------------- FUNCTIONS ---------------------------------------------
//------------------------------------------------------------------------------------------------------------------


//Detects the change of value of a variable
boolean detectChange(float var, float[] track) {
  track[0] = track[1];
  track[1] = var;

  return track[0] != track[1];
}

//Shows the slider of the current wall
void currentSlider() {
  if (exportInterface) {
    for (int i = 1; i < cp5.size(); i++) {
      if (i == editedWall) {
        cp5.get(i).show();
      } else {
        cp5.get(i).hide();
      }
    }
  } else {
    cp5.get(cp5.size() - 1).show();
  }
}

//Interaction whit the dropdown menu
void dropdown(int n) {
  imgID[editedWall - 1] = n;
  for (int i = 0; i < grids.size(); i++) {
    grids.get(i).loadImageGrid(imgID[i]);
  }
}

//Set the options of the sliders
void setOptions() {
  options[0][0] = gridOffset0;
  options[0][1] = gridOffset1;
  options[0][2] = gridOffset2;
  options[0][3] = gridOffset3;
  options[0][4] = gridOffset4;

  options[1][0] = gridSize0;
  options[1][1] = gridSize1;
  options[1][2] = gridSize2;
  options[1][3] = gridSize3;
  options[1][4] = gridSize4;

  options[2][0] = contrast0;
  options[2][1] = contrast1;
  options[2][2] = contrast2;
  options[2][3] = contrast3;
  options[2][4] = contrast4;

  options[3][0] = midCont0;
  options[3][1] = midCont1;
  options[3][2] = midCont2;
  options[3][3] = midCont3;
  options[3][4] = midCont4;

  options[4][0] = minBri0;
  options[4][1] = minBri1;
  options[4][2] = minBri2;
  options[4][3] = minBri3;
  options[4][4] = minBri4;

  options[5][0] = maxBri0;
  options[5][1] = maxBri1;
  options[5][2] = maxBri2;
  options[5][3] = maxBri3;
  options[5][4] = maxBri4;
}

//Draws the graphic of the plan
void drawGraphics(PGraphics pg) {
  colorMode(RGB, 255, 255, 255);
  pg.beginDraw();
  pg.background(255);
  for (int i = 0; i < grids.size(); i++) {
    Grid g = grids.get(i);
    int hookW = 50;
    int hookH = 150;
    int hookB = 5;
    int hookOff = 20;
    int w = 400;
    int h = 600;
    int insert = h + (hookB*2) - (hookOff + hookH)*2;

    pg.noFill();
    pg.stroke(255, 0, 0);
    pg.strokeWeight(2);

    pg.push();
    pg.translate((hookW + hookB + w + hookB)*i, 150);
    
    //Contour
    pg.beginShape();
    pg.vertex(0, hookOff);
    pg.vertex(hookW, hookOff);
    pg.vertex(hookW, 0);
    pg.vertex(hookW + hookB + w + hookB + hookW, 0);
    pg.vertex(hookW + hookB + w + hookB + hookW, hookOff);
    pg.vertex(hookW + hookB + w + hookB, hookOff);
    pg.vertex(hookW + hookB + w + hookB, hookOff + hookH);
    pg.vertex(hookW + hookB + w + hookB + hookW, hookOff + hookH);
    pg.vertex(hookW + hookB + w + hookB + hookW, hookOff + hookH + insert);
    pg.vertex(hookW + hookB + w + hookB, hookOff + hookH + insert);
    pg.vertex(hookW + hookB + w + hookB, hookOff + hookH + insert + hookH);
    pg.vertex(hookW + hookB + w + hookB + hookW, hookOff + hookH + insert + hookH);
    pg.vertex(hookW + hookB + w + hookB + hookW, hookOff + hookH + insert + hookH + hookOff);
    pg.vertex(hookW, hookOff + hookH + insert + hookH + hookOff);
    pg.vertex(hookW, hookOff + hookH + insert + hookH);
    pg.vertex(0, hookOff + hookH + insert + hookH);
    pg.vertex(0, hookOff + hookH + insert);
    pg.vertex(hookW, hookOff + hookH + insert);
    pg.vertex(hookW, hookOff + hookH);
    pg.vertex(0, hookOff + hookH);
    pg.endShape(CLOSE);

    if (mode == engraved) {
      pg.fill(0);
      pg.stroke(0);
      pg.strokeWeight(2);
    }
    
    //Dots
    for (int j = 0; j < g.posX.size(); j++) {
      pg.circle(g.posX.get(j) + hookW, g.posY.get(j), g.sizes.get(j));
    }

    pg.pop();
  }
  pg.endDraw();
  colorMode(HSB, 360, 100, 100);
}

//Checks the interaction with the slider
public void controlEvent(ControlEvent theEvent) {
  String name = theEvent.getController().getName();
  float value = theEvent.getController().getValue();

  if (name == "<") {
    editedWallTrack[0] = editedWall;
    if (editedWall - 1 < 1) {
      editedWall = wallNb;
    } else {
      editedWall--;
    }
    editedWallTrack[1] = editedWall;
    t = 0;
  } else if (name == ">") {
    editedWallTrack[0] = editedWall;
    if (editedWall + 1 > wallNb) {
      editedWall = 1;
    } else {
      editedWall++;
    }
    editedWallTrack[1] = editedWall;
    t = 0;
  }

  if (CP5Enable) {
    if (name == "save") {
      record = true;
    }

    if (name == "render") {
      if (exportInterface) {
        println("RENDERING...");
        for (int i = 0; i < wallNb; i++) {
          walls.get(i).id = i+1;
          walls.get(i).update();
        }
      }

      for (int i = 0; i < cp5.size(); i++) {
        cp5.get(i).hide();
      }
      showCP5 = false;
      exportInterface = !exportInterface;
    }

    if (name == "back") {
      for (int i = 0; i < cp5.size(); i++) {
        cp5.get(i).show();
      }
      showCP5 = true;
      exportInterface = !exportInterface;
    }
  }


  if (name == "wallNb") {
    if (editedWall > int(value)) {
      editedWall = int(value);
      editedWallTrack[1] = editedWall;
      t = 0;
    }
  }


  if (name == "lightHue") {
    if (mode == engraved) {
      for (int i = 0; i < wallNb; i++) {
        walls.get(i).engravedWall();
      }
    }
  }
}

//Checks the mousewheel event
void mouseWheel(MouseEvent event) {
  int e = event.getCount();
  int incmt = e*100;
  if (!exportInterface) {
    zoom -= incmt;
  }
}
