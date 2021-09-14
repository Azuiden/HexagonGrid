import processing.pdf.*; //for saving as pdf

int cols, rows, rndHole;
float cellWidth, cellHeight, vertSpaceAdj;
////COLORS////
color bk;
color[] BK = {#87A5A5,#BFA8BE,#D9896D,#F26666,#A0DEAE,#40352C};
color[] Color1 = {#8C3E37,#5E608C,#F29B88,#D9C2AD,#A64B63,#537D91}; //darker colors
color[] Color2 = {#BF573F,#E9F0F2,#F2CC85,#F2D6B3,#F2AB6D,#DEA895}; // lighter colors
//The indexes match intended palette so they should be used together (I.E. Color1[0] goes w/ Color2[0])

void setup() {
size(1000,1000);
beginRecord(PDF,"Output/hexagon_grid.pdf"); //for saving as pdf
bk = BK[int(random(BK.length))];

//Hexagon parameters
float radius = 70;
int translateY = 12;
rndHole = 10; //controls how often a hexagon will have a hole
vertSpaceAdj = 1.2; //adjusts the space between columns

noLoop();
}

void draw(){
noStroke();

background(bk);
cols = 10;
rows = 10;
cellWidth = width/cols;
cellHeight = height/rows;
  
  for (int r = 0; r < rows; r++){
    for (let c = 0; c < cols; c++){
      int rndColor = int(random(Color1.length));
      float centerX = c * cellWidth/vertSpaceAdj;
      float centerY = r * cellHeight;
      
      if(c % 2 != 0){
        centerY = j * cellHeight + cellHeight/2;
      }
      
      color color1 = Color1[rndColor];
      color color2 = Color2[rndColor];
      
      fill(color1);
      HexagonShadow(centerX, centerY, radius, translateY);
      fill(color2);
      Hexagon(centerX, centerY, radius);
      
      if(random(rndHole) < 1) //randomly add hole to hexagon
      {
        pushMatrix();
        translate(centerX, centerY+translateY/2); //translate so that 0,0 is center of shape
        fill(color1);
        rotate(PI); //rotate at 0,0
        scale(1.1,1);
        HexagonShadow(0, 0, radius-(radius*.5), translateY);
        fill(bk);
        Hexagon(0, 0, radius-(radius*.5));
        popMatrix();
      }
      
    }//end of rows for loop
  }//end of columns for loop
  
  endRecord();//for saving as pdf
  
} //end of void draw()

void Hexagon(float centerX, float centerY, float radius) {
  beginShape();
  for (float a = 0; a < TWO_PI; a += TWO_PI / 6) {
    float sx = centerX + cos(a) * radius;
    float sy = centerY + sin(a) * radius;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void HexagonShadow(float centerX, float centerY, float radius, int translateY) {
  //creates a dropshadow for Hexagon() by offsetting a hexagon and filling the space between the furthest points with a rectangle
 Hexagon(centerX,centerY + translateY,radius); 
 //the 4 coordinates of the quad
 //Could plug these into the quad() but this is easier to read for me
 float[] xy1 = {centerX + radius,centerY}; //TL
 float[] xy2 = {centerX + radius,centerY + translateY}; //TR
 float[] xy3 = {centerX - radius,centerY}; //BL
 float[] xy4 = {centerX - radius,centerY + translateY}; //BR
 quad(xy1[0],xy1[1],xy2[0],xy2[1],xy3[0],xy3[1],xy4[0],xy4[1]);
}
