class Wall {
  //Variables
  //Wall
  WB_GeometryFactory gf=new WB_GeometryFactory();
  ArrayList<WB_Point> shell;
  ArrayList<WB_Point>[] holes;
  ArrayList<WB_Point> hole = new ArrayList<WB_Point>();
  WB_Polygon[] polygons, polygonsA;
  HE_Mesh mesh, meshA;

  Grid grid;

  PVector[] shapePointsR = new PVector[12];
  float[] shapeAnglesR = new float[12];
  float[] shapeRadiusR = new float[12];

  PVector[] shapePointsL = new PVector[12];
  float[] shapeAnglesL = new float[12];
  float[] shapeRadiusL = new float[12];

  PVector[] shapePointsT = new PVector[4];
  float[] shapeAnglesT = new float[4];
  float[] shapeRadiusT = new float[4];

  PVector[] shapePointsB = new PVector[4];
  float[] shapeAnglesB = new float[4];
  float[] shapeRadiusB = new float[4];

  PVector[] shapePointsA = new PVector[20];
  float[] shapeAnglesA = new float[20];
  float[] shapeRadiusA = new float[20];

  int w = 400;
  int h = 600;

  PGraphics wall;
  PVector topCorner;
  PVector bottomCorner;

  int id;

  //Constructor
  Wall() {
  }

  //Calculates the angles and the radius of every points of the shape
  void setShape() {
    //Size variables
    int hookW = 50;
    int hookH = 150;
    int hookB = 5;
    int hookOff = 20;
    float bufferWL = grid.posX.get(0) - w/2 - grid.step/2;
    float bufferWR = grid.posX.get(grid.posX.size() - 1) - w/2 + grid.step/2;
    float bufferHT = grid.posY.get(0) - h/2 - grid.step/2;
    float bufferHB = grid.posY.get(grid.posY.size() - 1) - h/2 + grid.step/2;
    int insert = h + (hookB*2) - (hookOff + hookH)*2;
    topCorner = new PVector(bufferWL, bufferHT);
    bottomCorner = new PVector(bufferWR, bufferHB);

    //Points of right side of the shape
    shapePointsR[0] = new PVector(w/2 + hookB + hookW, insert/2);
    shapePointsR[1] = new PVector(w/2 + hookB, insert/2);
    shapePointsR[2] = new PVector(w/2 + hookB, insert/2 + hookH);
    shapePointsR[3] = new PVector(w/2 + hookB + hookW, insert/2 + hookH);
    shapePointsR[4] = new PVector(w/2 + hookB + hookW, insert/2 + hookH + hookOff);
    shapePointsR[5] = new PVector(bufferWR, insert/2 + hookH + hookOff);
    shapePointsR[6] = new PVector(bufferWR, -insert/2 - hookH - hookOff);
    shapePointsR[7] = new PVector(w/2 + hookB + hookW, -insert/2 - hookH - hookOff);
    shapePointsR[8] = new PVector(w/2 + hookB + hookW, -insert/2 - hookH);
    shapePointsR[9] = new PVector(w/2 + hookB, -insert/2 - hookH);
    shapePointsR[10] = new PVector(w/2 + hookB, -insert/2);
    shapePointsR[11] = new PVector(w/2 + hookB + hookW, -insert/2);

    //Radius of right side of the shape
    for (int i = 0; i < shapeRadiusR.length; i++) {
      shapeRadiusR[i] = dist(0, 0, shapePointsR[i].x, shapePointsR[i].y);
    }

    //Angles of right side of the shape
    for (int i = 0; i<=5; i++) {
      shapeAnglesR[i] = abs(atan(shapePointsR[i].y / shapePointsR[i].x));
    }
    for (int i = 6; i<=11; i++) {
      shapeAnglesR[i] = TWO_PI - abs(atan(shapePointsR[i].y / shapePointsR[i].x));
    }

    //Points of left side of the shape
    shapePointsL[0] = new PVector(bufferWL, insert/2 + hookH + hookOff);
    shapePointsL[1] = new PVector(-w/2 - hookB, insert/2 + hookH + hookOff);
    shapePointsL[2] = new PVector(-w/2 - hookB, insert/2 + hookH);
    shapePointsL[3] = new PVector(-w/2 - hookB - hookW, insert/2 + hookH);
    shapePointsL[4] = new PVector(-w/2 - hookB - hookW, insert/2);
    shapePointsL[5] = new PVector(-w/2 - hookB, insert/2);
    shapePointsL[6] = new PVector(-w/2 - hookB, -insert/2);
    shapePointsL[7] = new PVector(-w/2 - hookB - hookW, -insert/2);
    shapePointsL[8] = new PVector(-w/2 - hookB - hookW, -insert/2 - hookH);
    shapePointsL[9] = new PVector(-w/2 - hookB, -insert/2 - hookH);
    shapePointsL[10] = new PVector(-w/2 - hookB, -insert/2 - hookH - hookOff);
    shapePointsL[11] = new PVector(bufferWL, -insert/2 - hookH - hookOff);

    //Radius of left side of the shape
    for (int i = 0; i < shapeRadiusL.length; i++) {
      shapeRadiusL[i] = dist(0, 0, shapePointsL[i].x, shapePointsL[i].y);
    }

    //Angles of left side of the shape
    for (int i = 0; i<=5; i++) {
      shapeAnglesL[i] = PI - abs(atan(shapePointsL[i].y / shapePointsL[i].x));
    }
    for (int i = 6; i<=11; i++) {
      shapeAnglesL[i] = PI + abs(atan(shapePointsL[i].y / shapePointsL[i].x));
    }

    //Points of top side of the shape
    shapePointsT[0] = new PVector(bufferWR, bufferHT);
    shapePointsT[1] = new PVector(bufferWL, bufferHT);
    shapePointsT[2] = new PVector(bufferWL, -insert/2 - hookH - hookOff);
    shapePointsT[3] = new PVector(bufferWR, -insert/2 - hookH - hookOff);

    //Radius of top side of the shape
    for (int i = 0; i < shapeRadiusT.length; i++) {
      shapeRadiusT[i] = dist(0, 0, shapePointsT[i].x, shapePointsT[i].y);
    }

    //Angles of top side of the shape
    shapeAnglesT[0] = atan(shapePointsT[0].y / shapePointsT[0].x);
    shapeAnglesT[1] = PI + atan(shapePointsT[1].y / shapePointsT[1].x);
    shapeAnglesT[2] = PI + atan(shapePointsT[2].y / shapePointsT[2].x);
    shapeAnglesT[3] = TWO_PI - abs(atan(shapePointsT[3].y / shapePointsT[3].x));


    //Points of bottom side of the shape
    shapePointsB[0] = new PVector(bufferWR, bufferHB);
    shapePointsB[1] = new PVector(bufferWR, insert/2 + hookH + hookOff);
    shapePointsB[2] = new PVector(bufferWL, insert/2 + hookH + hookOff);
    shapePointsB[3] = new PVector(bufferWL, bufferHB);

    //Radius of bottom side of the shape
    for (int i = 0; i < shapeRadiusB.length; i++) {
      shapeRadiusB[i] = dist(0, 0, shapePointsB[i].x, shapePointsB[i].y);
    }

    //Angles of bottom side of the shape
    shapeAnglesB[0] = atan(shapePointsB[0].y / shapePointsB[0].x);
    shapeAnglesB[1] = atan(shapePointsB[1].y / shapePointsB[1].x);
    shapeAnglesB[2] = PI - abs(atan(shapePointsB[2].y / shapePointsB[2].x));
    shapeAnglesB[3] = PI - abs(atan(shapePointsB[3].y / shapePointsB[3].x));

    //Points of the acrylic the shape
    shapePointsA[0] = shapePointsR[0];
    shapePointsA[1] = shapePointsR[1];
    shapePointsA[2] = shapePointsR[2];
    shapePointsA[3] = shapePointsR[3];
    shapePointsA[4] = shapePointsR[4];
    shapePointsA[5] = shapePointsL[1];
    shapePointsA[6] = shapePointsL[2];
    shapePointsA[7] = shapePointsL[3];
    shapePointsA[8] = shapePointsL[4];
    shapePointsA[9] = shapePointsL[5];
    shapePointsA[10] = shapePointsL[6];
    shapePointsA[11] = shapePointsL[7];
    shapePointsA[12] = shapePointsL[8];
    shapePointsA[13] = shapePointsL[9];
    shapePointsA[14] = shapePointsL[10];
    shapePointsA[15] = shapePointsR[7];
    shapePointsA[16] = shapePointsR[8];
    shapePointsA[17] = shapePointsR[9];
    shapePointsA[18] = shapePointsR[10];
    shapePointsA[19] = shapePointsR[11];

    //Radius of the acrylic the shape
    for (int i = 0; i < shapeRadiusA.length; i++) {
      shapeRadiusA[i] = dist(0, 0, shapePointsA[i].x, shapePointsA[i].y);
    }

    //Angles of the acrylic the shape
    shapeAnglesA[0] = shapeAnglesR[0];
    shapeAnglesA[1] = shapeAnglesR[1];
    shapeAnglesA[2] = shapeAnglesR[2];
    shapeAnglesA[3] = shapeAnglesR[3];
    shapeAnglesA[4] = shapeAnglesR[4];
    shapeAnglesA[5] = shapeAnglesL[1];
    shapeAnglesA[6] = shapeAnglesL[2];
    shapeAnglesA[7] = shapeAnglesL[3];
    shapeAnglesA[8] = shapeAnglesL[4];
    shapeAnglesA[9] = shapeAnglesL[5];
    shapeAnglesA[10] = shapeAnglesL[6];
    shapeAnglesA[11] = shapeAnglesL[7];
    shapeAnglesA[12] = shapeAnglesL[8];
    shapeAnglesA[13] = shapeAnglesL[9];
    shapeAnglesA[14] = shapeAnglesL[10];
    shapeAnglesA[15] = shapeAnglesR[7];
    shapeAnglesA[16] = shapeAnglesR[8];
    shapeAnglesA[17] = shapeAnglesR[9];
    shapeAnglesA[18] = shapeAnglesR[10];
    shapeAnglesA[19] = shapeAnglesR[11];
  }

  //Creates a wall from the grid
  void update() {

    //Sets the total number of polygons
    int polyNum = 0;
    if (mode == pierced) polyNum = grid.posX.size() + 4;
    else if (mode == engraved) polyNum = 4;

    //Creates the polygons of the wall
    polygons = new WB_Polygon[polyNum];
    makePolygon(polygons, 0);

    //Creates the polygons of the full wall for the extruded sides
    if (mode == engraved) {
      //Creates the polygons of the wall
      polygonsA = new WB_Polygon[1];
      makeBorder(polygonsA, 0);
      //Creates a mesh form the polygons
      HEC_FromPolygons creatorA = new HEC_FromPolygons();
      creatorA.setPolygons(polygonsA);
      meshA = new HE_Mesh(creatorA);
    }

    //Creates a mesh form the polygons
    HEC_FromPolygons creator = new HEC_FromPolygons();
    creator.setPolygons(polygons);
    mesh = new HE_Mesh(creator);

    //Sets up the extrusion parametres
    HEM_Extrude modifier;
    modifier=new HEM_Extrude();
    modifier.setDistance(10);// extrusion distance, set to 0 for inset faces
    modifier.setRelative(false);// treat chamfer as relative to face size or as absolute value
    modifier.setChamfer(0);// chamfer for non-hard edges
    modifier.setHardEdgeChamfer(80);// chamfer for hard edges
    modifier.setThresholdAngle(Math.PI*0.5);// treat edges sharper than this angle as hard edges
    modifier.setFuse(true);// try to fuse planar adjacent planar faces created by the extrude
    modifier.setPeak(true);//if absolute chamfer is too large for face, create a peak on the face

    //Extrude the meshs
    mesh.modify(modifier);
    if (mode == engraved)
      meshA.modify(modifier);

    //Prints a message indicading the wall has finished rendering
    println("WALL " + id + " DONE");
  }

  //Makes the polygon of the wall from the radiuses and the angles
  void makePolygon(WB_Polygon[] pol, int z) {

    //Creates the pierced section
    if (mode == pierced) {
      int sides = 6;

      for (int j = 0; j < pol.length - 4; j++) {
        shell= new ArrayList<WB_Point>();
        for (int i = 0; i < 4; i ++) {
          shell.add(gf.createPointFromPolar(sqrt(pow(grid.step/2, 2) * 2) + 2, (i * HALF_PI) + HALF_PI/2).addSelf(grid.posX.get(j) - w/2, grid.posY.get(j) - h/2, z));
        }


        holes = new ArrayList[1];
        hole=new ArrayList<WB_Point>();
        for (int i=0; i<sides; i++) {
          float size = grid.sizes.get(j)/2;
          if (size > 0) {
            size += 1;
          }
          hole.add(gf.createPointFromPolar(size, -TWO_PI/sides*i).addSelf(grid.posX.get(j) - w/2, grid.posY.get(j) - h/2, z));
        }
        holes[0] = hole;

        //Adds the holes to the polygon
        pol[j] = gf.createPolygonWithHoles(shell, holes);
      }
    }

    //Draws the engravings on the wall
    if (mode == engraved) {
      engravedWall();
    }

    setShape();
    holes = new ArrayList[1];
    hole=new ArrayList<WB_Point>();
    for (int i=0; i<3; i++) {
      hole.add(gf.createPointFromPolar(0, 0).addSelf(0, 0, z));
    }
    holes[0] = hole;

    shell = new ArrayList<WB_Point>();
    for (int i = 0; i < shapePointsT.length; i ++) {
      shell.add(gf.createPointFromPolar(shapeRadiusB[i], shapeAnglesB[i]).addSelf(0, 0, z));
    }
    //Adds the holes to the polygon
    pol[pol.length - 4] = gf.createPolygonWithHoles(shell, holes);



    shell = new ArrayList<WB_Point>();
    for (int i = 0; i < shapePointsT.length; i ++) {
      shell.add(gf.createPointFromPolar(shapeRadiusT[i], shapeAnglesT[i]).addSelf(0, 0, z));
    }
    //Adds the holes to the polygon
    pol[pol.length - 3] = gf.createPolygonWithHoles(shell, holes);



    shell = new ArrayList<WB_Point>();
    for (int i = 0; i < shapePointsR.length; i ++) {
      shell.add(gf.createPointFromPolar(shapeRadiusR[i], shapeAnglesR[i]).addSelf(0, 0, z));
    }
    //Adds the holes to the polygon
    pol[pol.length - 2] = gf.createPolygonWithHoles(shell, holes);



    shell = new ArrayList<WB_Point>();
    for (int i = 0; i < shapePointsL.length; i ++) {
      shell.add(gf.createPointFromPolar(shapeRadiusL[i], shapeAnglesL[i]).addSelf(0, 0, z));
    }
    //Adds the holes to the polygon
    pol[pol.length - 1] = gf.createPolygonWithHoles(shell, holes);
  }

  //Creates the polygons of the full wall for the extruded sides
  void makeBorder(WB_Polygon[] pol, int z) {
    setShape();
    holes = new ArrayList[1];
    hole=new ArrayList<WB_Point>();
    for (int i=0; i<3; i++) {
      hole.add(gf.createPointFromPolar(shapeRadiusA[19], shapeAnglesA[19]).addSelf(0, 0, z));
    }
    holes[0] = hole;

    shell = new ArrayList<WB_Point>();
    for (int i = 0; i < shapePointsA.length; i ++) {
      shell.add(gf.createPointFromPolar(shapeRadiusA[i], shapeAnglesA[i]).addSelf(0, 0, z));
    }
    //Adds the holes to the polygon
    pol[pol.length - 1] = gf.createPolygonWithHoles(shell, holes);
  }

  //Draws the engravings on the wall
  void engravedWall() {
    wall = createGraphics(grid.windowW, grid.windowH);
    wall.beginDraw();
    wall.colorMode(HSB, 360, 100, 100);
    wall.background(lightHue, 100, 100, 0);
    wall.fill(lightHue, 10, 100);
    wall.stroke(lightHue, 10, 100);
    for (int j = 0; j < grid.posX.size(); j++) {
      wall.circle(grid.posX.get(j), grid.posY.get(j), grid.sizes.get(j));
    }
    wall.endDraw();
  }
}
