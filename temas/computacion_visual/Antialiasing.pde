import java.util.*;

class G_HorizontalScrollBar{
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;
  
  public G_HorizontalScrollBar(float xp, float yp, int sw, int sh, int l){
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)(sw) / (float)(widthtoheight);
    xpos = xp;
    ypos = yp - sheight / 2;
    spos = xpos + swidth / 2 - sheight / 2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }
  
  void update() {
      if (overEvent()) {
        over = true;
      } else {
        over = false;
      }
      if (mousePressed && over) {
        locked = true;
      }
      if (!mousePressed) {
        locked = false;
      }
      if (locked) {
        newspos = constrain(mouseX - sheight / 2, sposMin, sposMax);
      }
      if (Math.abs(newspos - spos) > 1) {
        spos = spos + (newspos - spos) / loose;
      }
    }

    float constrain(float val, float minv, float maxv) {
      return Math.min(Math.max(val, minv), maxv);
    }

    boolean overEvent() {
      if (mouseX > xpos && mouseX < xpos+swidth &&
         mouseY > ypos && mouseY < ypos+sheight) {
        return true;
      } else {
        return false;
      }
    }

    void display() {
      noStroke();
      fill(204);
      rect(xpos, ypos, swidth, sheight);
      if (over || locked) {
        fill(0, 0, 0);
      } else {
        fill(102, 102, 102);
      }
      rect(spos, ypos, sheight, sheight);
    }

    float getPos() {
      // Convert spos to be values between
      // 0 and the total width of the scrollbar
      return spos * ratio;
    }
}

int anchoVentana = 1200, altoVentana = 640;
float minimoLados = 3.0f, maximoLados = 15.0f;
float minimoPixeles = 15.0f, maximoPixeles = 100.0f;
G_HorizontalScrollBar hs1, hs2;
PShape poligono;
ArrayList<Float> puntosX;
ArrayList<Float> puntosY;
int margen = 10, dist = 10;
int muestrasLado = 3;
  
ArrayList<ArrayList<Float>> noAnti, anti;
  
int numeroLadosPoligono = 1;
int numeroPixelesLado = 1;
int longitudVistaPrevia = 250;
  
float a = (float)(2 * Math.PI / numeroLadosPoligono);

void setup(){
  textSize(18);
  hs1 = new G_HorizontalScrollBar(40, 40, 200, 20, 1);
  hs2 = new G_HorizontalScrollBar(40, 90, 200, 20, 1);
  size(anchoVentana, altoVentana);
}

void draw(){
  background(46, 254, 100);
    numeroLadosPoligono = numeroLados(hs1.sposMin, hs1.sposMax, hs1.spos);
    numeroPixelesLado = numeroPixeles(hs2.sposMin, hs2.sposMax, hs2.spos);
    a = (float)(2 * Math.PI / numeroLadosPoligono);
    fill(0);
    text("Numero de lados del Poligono: " + numeroLadosPoligono, 25, 25);
    text("Numero de pixeles de lado: " + numeroPixelesLado, 25, 75);
    rectMode(CORNER);
    hs1.update();
    hs1.display();
    hs2.update();
    hs2.display();
    fill(255);
    stroke(0);
    rectMode(RADIUS);
    rect(50 + longitudVistaPrevia / 2, 300 + longitudVistaPrevia / 2, longitudVistaPrevia / 2, longitudVistaPrevia / 2);
    rect(100 + 3 * longitudVistaPrevia / 2, 300 + longitudVistaPrevia / 2, longitudVistaPrevia / 2, longitudVistaPrevia / 2);
    
    stroke(127);
    for(int control = 1; control < numeroPixelesLado; control++){
      line(100 + longitudVistaPrevia, 300.0f + (float)(control * longitudVistaPrevia / numeroPixelesLado), 100 + longitudVistaPrevia + longitudVistaPrevia, 300.0f + (float)(control * longitudVistaPrevia / numeroPixelesLado));
      line(100.0f + longitudVistaPrevia + (float)(control * longitudVistaPrevia / numeroPixelesLado), 300 + longitudVistaPrevia, 100.0f + longitudVistaPrevia + (float)(control * longitudVistaPrevia / numeroPixelesLado), 300);
    }
    stroke(0);
    
    poligono = createShape();
    poligono.beginShape();
    poligono.noFill();
    poligono.strokeWeight(3);
    
    puntosX = new ArrayList<Float>();
    puntosY = new ArrayList<Float>();
    
    for(int control = 0; control < numeroLadosPoligono; control++){
      float x = 50 + longitudVistaPrevia / 2 + longitudVistaPrevia / 2 * (float)Math.cos(a * control), y = 300 + longitudVistaPrevia / 2 + longitudVistaPrevia / 2 * (float)Math.sin(a * control);
      poligono.vertex(x, y);
      puntosX.add(x);
      puntosY.add(y);
    }
    
    for(int control = 0; control < numeroLadosPoligono; control++){
      if(control < numeroLadosPoligono - 1){
        float x1 = puntosX.get(control), x2 = puntosX.get(control + 1);
        float y1 = puntosY.get(control), y2 = puntosY.get(control + 1);
        for(float t = 0.0f; t < 1.0f; t += 0.01f){
          puntosX.add((1 - t) * x1 + t * x2);
          puntosY.add((1 - t) * y1 + t * y2);
        }
      }else{
        float x1 = puntosX.get(control), x2 = puntosX.get(0);
        float y1 = puntosY.get(control), y2 = puntosY.get(0);
        for(float t = 0.0f; t < 1.0f; t += 0.01f){
          puntosX.add((1 - t) * x1 + t * x2);
          puntosY.add((1 - t) * y1 + t * y2);
        }
      }
    }
    
    
    
    
    //fill(0);
    noAnti = new ArrayList<ArrayList<Float>>();
    for(int control = 0; control < numeroPixelesLado; control++){
      noAnti.add(new ArrayList<Float>());
      for(int control1 = 0; control1 < numeroPixelesLado; control1++){
        noAnti.get(control).add(255.0f);
      }
    }
    ArrayList<Float> nodeList = new ArrayList<Float>();
    noAnti.add(nodeList);
    for(int i = 0; i < numeroPixelesLado; i++){
      for(int j = 0; j < numeroPixelesLado; j++){
        float minx = 50 + i * longitudVistaPrevia / numeroPixelesLado, miny = 300 + j * longitudVistaPrevia / numeroPixelesLado;
        float maxx = 50 + (i + 1) * longitudVistaPrevia / numeroPixelesLado, maxy = 300 + (j + 1) * longitudVistaPrevia / numeroPixelesLado;
        for(int k = 0; k < puntosX.size(); k++){
          if((minx < puntosX.get(k) && puntosX.get(k) < maxx) && (miny < puntosY.get(k) && puntosY.get(k) < maxy)){
            noAnti.get(i).set(j, 0.0f);
            fill(0);
            rect(300 + minx + longitudVistaPrevia / numeroPixelesLado / 2, miny + longitudVistaPrevia / numeroPixelesLado / 2, longitudVistaPrevia / numeroPixelesLado / 2, longitudVistaPrevia / numeroPixelesLado / 2);
            break;
          }
        }
      }
    }
    
    anti = new ArrayList<ArrayList<Float>>();
    for(int control = 0; control < numeroPixelesLado * muestrasLado; control++){
      anti.add(new ArrayList<Float>());
      for(int control1 = 0; control1 < numeroPixelesLado * muestrasLado; control1++){
        anti.get(control).add(255.0f);
      }
    }
    nodeList = new ArrayList<Float>();
    anti.add(nodeList);
    for(int i = 0; i < numeroPixelesLado * muestrasLado; i++){
      for(int j = 0; j < numeroPixelesLado * muestrasLado; j++){
        float minx = 50 + i * longitudVistaPrevia / numeroPixelesLado / muestrasLado, miny = 100 + j * longitudVistaPrevia / numeroPixelesLado / muestrasLado;
        float maxx = 50 + (i + 1) * longitudVistaPrevia / numeroPixelesLado / muestrasLado, maxy = 100 + (j + 1) * longitudVistaPrevia / numeroPixelesLado / muestrasLado;
        for(int k = 0; k < puntosX.size(); k++){
          if((minx < puntosX.get(k) && puntosX.get(k) < maxx) && (miny < puntosY.get(k) && puntosY.get(k) < maxy)){
            anti.get(i).set(j, 0.0f);
            fill(0);
            rect(250 + minx + longitudVistaPrevia / numeroPixelesLado / 2 / muestrasLado, -250 + miny + longitudVistaPrevia / numeroPixelesLado / 2 / muestrasLado, longitudVistaPrevia / numeroPixelesLado / 2 / muestrasLado, longitudVistaPrevia / numeroPixelesLado / 2 / muestrasLado);
            break;
          }
        }
      }
    }
    
    
    drawImage(noAnti, numeroPixelesLado, (int)(longitudVistaPrevia * 2), 600, 300);
    
    poligono.endShape(CLOSE);
    shape(poligono, 0, 0);
}

public void drawImage(ArrayList<ArrayList<Float>> matrix, int dim, int largo, int xPos, int yPos){
    stroke(0);
    for(int i = 0; i < dim; i++){
      
      for(int j = 0; j < dim; j++){
        
        float minx = xPos + i * largo / dim, miny = yPos + j * (largo / dim);
        float maxx = xPos + (i + 1) * largo / dim, maxy = yPos + (j + 1) * (largo / dim);
        
        fill(matrix.get(i).get(j));
        //rect(xPos + minx + largo / dim / 2, yPos + miny + largo / dim / 2, largo / dim / 2, largo / dim / 2);
        rect(xPos + minx + largo / dim / 2, yPos + miny + largo / dim / 2, largo, largo);
      }
    }
  }
  
  public int numeroLados(float minV, float maxV, float s){
    return (int)((maximoLados - minimoLados) / (maxV - minV) * (s - minV) + minimoLados); 
  }
  public int numeroPixeles(float minV, float maxV, float s){
    return (int)((maximoPixeles - minimoPixeles) / (maxV - minV) * (s - minV) + minimoPixeles); 
  }