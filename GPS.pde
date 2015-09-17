import processing.opengl.*;
import com.modestmaps.*;
import com.modestmaps.core.*;
import com.modestmaps.geo.*;
import com.modestmaps.providers.*;
int[] GPS_coord = new int[2];
float[] GPS_coordf = new float[2];
byte  GPS_numSat;
byte  GPS_Fixed;
class GButton {
  
  float x, y, w, h;
  
  GButton(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  } 
  
  boolean mouseOver() {
    return (mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h);
  }
  
  void draw() {
    stroke(80);
    fill(mouseOver() ? 255 : 220);
    rect(x,y,w,h); 
  }
  
}

class GZoomButton extends GButton {
  
  boolean in = false;
  
  GZoomButton(float x, float y, float w, float h, boolean in) {
    super(x, y, w, h);
    this.in = in;
  }
  
  void draw() {
    super.draw();
    stroke(0);
    line(x+3,y+h/2,x+w-3,y+h/2);
    if (in) {
      line(x+w/2,y+3,x+w/2,y+h-3);
    }
  }
  
}

class GPanButton extends GButton {
  
  int dir = UP;
  
  GPanButton(float x, float y, float w, float h, int dir) {
    super(x, y, w, h);
    this.dir = dir;
  }
  
  void draw() {
    super.draw();
    stroke(0);
    switch(dir) {
      case UP:
        line(x+w/2,y+3,x+w/2,y+h-3);
        line(x-3+w/2,y+6,x+w/2,y+3);
        line(x+3+w/2,y+6,x+w/2,y+3);
        break;
      case DOWN:
        line(x+w/2,y+3,x+w/2,y+h-3);
        line(x-3+w/2,y+h-6,x+w/2,y+h-3);
        line(x+3+w/2,y+h-6,x+w/2,y+h-3);
        break;
      case LEFT:
        line(x+3,y+h/2,x+w-3,y+h/2);
        line(x+3,y+h/2,x+6,y-3+h/2);
        line(x+3,y+h/2,x+6,y+3+h/2);
        break;
      case RIGHT:
        line(x+3,y+h/2,x+w-3,y+h/2);
        line(x+w-3,y+h/2,x+w-6,y-3+h/2);
        line(x+w-3,y+h/2,x+w-6,y+3+h/2);
        break;
    }
  }
  
}
class GPSButton extends GButton {
  
  GPSButton(float x, float y, float w, float h) {
    super(x, y, w, h);
  }
  
  void draw() {
    super.draw();
    stroke(0);
    ellipse(x+w/2, y+h/2, w/2, h/2);
  }
  
}
//
// This is a test of the interactive Modest Maps library for Processing
// You must have modestmaps in your libraries folder, see INSTALL for details
//

// this is the only bit that's needed to show a map:
InteractiveMap map;
int BtnYOffset = 20;
// buttons take x,y and width,height:
GZoomButton out = new GZoomButton(5,5+BtnYOffset,14,14,false);
GZoomButton in = new GZoomButton(22,5+BtnYOffset,14,14,true);
GPanButton up = new GPanButton(14,25+BtnYOffset,14,14,UP);
GPanButton down = new GPanButton(14,57+BtnYOffset,14,14,DOWN);
GPanButton left = new GPanButton(5,41+BtnYOffset,14,14,LEFT);
GPanButton right = new GPanButton(22,41+BtnYOffset,14,14,RIGHT);
GPSButton gps = new GPSButton(14,90+BtnYOffset,14,14);

// all the buttons in one place, for looping:
GButton[] buttons = { 
  in, out, up, down, left, right, gps };

PFont gfont;

boolean gui = true;

double tx, ty, sc;

void setupGPS() {
  //size(640, 480, OPENGL);
  smooth();

  // create a new map, optionally specify a provider
  
  // OpenStreetMap would be like this:
  //map = new InteractiveMap(this, new OpenStreetMapProvider());
  // but it's a free open source project, so don't bother their server too much
  
  // AOL/MapQuest provides open tiles too
  // see http://developer.mapquest.com/web/products/open/map for terms
  // and this is how to use them:
  String template = "http://{S}.mqcdn.com/tiles/1.0.0/osm/{Z}/{X}/{Y}.png";
  String[] subdomains = new String[] { "otile1", "otile2", "otile3", "otile4" }; // optional
  map = new InteractiveMap(this, new TemplatedMapProvider(template, subdomains));
  
  // others would be "new Microsoft.HybridProvider()" or "new Microsoft.AerialProvider()"
  // the Google ones get blocked after a few hundred tiles
  // the Yahoo ones look terrible because they're not 256px squares :)

  // set the initial location and zoom level to London:
  map.setCenterZoom(new Location(51.500, -0.126), 11);  
  // zoom 0 is the whole world, 19 is street level
  // (try some out, or use getlatlon.com to search for more)

  // set a default font for labels
  gfont = createFont("Helvetica", 12);

  // enable the mouse wheel, for zooming
  addMouseWheelListener(new java.awt.event.MouseWheelListener() { 
    public void mouseWheelMoved(java.awt.event.MouseWheelEvent evt) { 
      mouseWheel(evt.getWheelRotation());
    }
  }); 

}

void DrawGPS() {
  
  readGPS();
  background(0);

  // draw the map:
  map.draw();
  // (that's it! really... everything else is interactions now)

  smooth();

  // draw all the buttons and check for mouse-over
  boolean hand = false;
  if (gui) {
    for (int i = 0; i < buttons.length; i++) {
      buttons[i].draw();
      hand = hand || buttons[i].mouseOver();
    }
  }

  // if we're over a button, use the finger pointer
  // otherwise use the cross
  // (I wish Java had the open/closed hand for "move" cursors)
  cursor(hand ? HAND : CROSS);

  // see if the arrow keys or +/- keys are pressed:
  // (also check space and z, to reset or round zoom levels)
  if (keyPressed) {
    if (key == CODED) {
      if (keyCode == LEFT) {
        map.tx += 5.0/map.sc;
      }
      else if (keyCode == RIGHT) {
        map.tx -= 5.0/map.sc;
      }
      else if (keyCode == UP) {
        map.ty += 5.0/map.sc;
      }
      else if (keyCode == DOWN) {
        map.ty -= 5.0/map.sc;
      }
    }  
    else if (key == '+' || key == '=') {
      map.sc *= 1.05;
    }
    else if (key == '_' || key == '-' && map.sc > 2) {
      map.sc *= 1.0/1.05;
    }
  }

  if (gui) {
    textFont(gfont, 12);

    // grab the lat/lon location under the mouse point:
    Location location = map.pointLocation(mouseX, mouseY);

    // draw the mouse location, bottom left:
    fill(0);
    noStroke();
    rect(5, height-5-g.textSize, textWidth("mouse: " + location), g.textSize+textDescent());
    fill(255,255,0);
    //textAlign(LEFT, BOTTOM);
    text("mouse: " + location, 5, height-5);

    // grab the center
    location = map.pointLocation(width/2, height/2);

    // draw the center location, bottom right:
    fill(0);
    noStroke();
    float rw = textWidth("map: " + location);
    rect(width-5-rw, height-5-g.textSize, rw, g.textSize+textDescent());
    fill(255,255,0);
    //textAlign(RIGHT, BOTTOM);
    text("map: " + location, width-5-rw, height-5);

    //location = new Location(51.500, -0.126);
    location = new Location(GPS_coordf[0],GPS_coordf[1]);
    Point2f p = map.locationPoint(location);

    //fill(0,255,128);
    fill(255,0,128);
    stroke(255,255,0);
    ellipse(p.x, p.y, 10, 10);
  }  

  println((float)map.sc);
  println((float)map.tx + " " + (float)map.ty);
  println();

}

void keyReleased() {
  if (key == 'g' || key == 'G') {
    gui = !gui;
  }
  else if (key == 's' || key == 'S') {
    save("modest-maps-app.png");
  }
  else if (key == 'z' || key == 'Z') {
    map.sc = pow(2, map.getZoom());
  }
  else if (key == ' ') {
    map.sc = 2.0;
    map.tx = -128;
    map.ty = -128; 
  }
}


// see if we're over any buttons, otherwise tell the map to drag
void mouseDragged() {
  boolean hand = false;
  if (gui) {
    for (int i = 0; i < buttons.length; i++) {
      hand = hand || buttons[i].mouseOver();
      if (hand) break;
    }
  }
  if (!hand) {
    map.mouseDragged(); 
  }
}

// zoom in or out:
void mouseWheel(int delta) {
  float sc = 1.0;
  if (delta < 0) {
    sc = 1.05;
  }
  else if (delta > 0) {
    sc = 1.0/1.05; 
  }
  float mx = mouseX - width/2;
  float my = mouseY - height/2;
  map.tx -= mx/map.sc;
  map.ty -= my/map.sc;
  map.sc *= sc;
  map.tx += mx/map.sc;
  map.ty += my/map.sc;
}

// see if we're over any buttons, and respond accordingly:
void mouseClicked() {
  if (in.mouseOver()) {
    map.zoomIn();
  }
  else if (out.mouseOver()) {
    map.zoomOut();
  }
  else if (up.mouseOver()) {
    map.panUp();
  }
  else if (down.mouseOver()) {
    map.panDown();
  }
  else if (left.mouseOver()) {
    map.panLeft();
  }
  else if (right.mouseOver()) {
    map.panRight();
  }
  else if (gps.mouseOver()) {
    //float sc = (float)map.sc;
    
    //int qsc = (int)sqrt(sc);
    //println("sc:"+sc+",qsc:"+qsc);
    //map.panRight();
    map.setCenterZoom(new Location(GPS_coordf[0], GPS_coordf[1]), map.getZoom());  
  }
}
void readGPS()
{
  while (myPort.available() >= 10)
  { 
    GPS_coord[0] = readInt32(myPort);
    GPS_coord[1] = readInt32(myPort);
    GPS_coordf[0] = (float)GPS_coord[0]/10000000;
    GPS_coordf[1] = (float)GPS_coord[1]/10000000;
    GPS_numSat = (byte)readChar(myPort);
    GPS_Fixed = (byte)readChar(myPort);
  }
  println("LAT:"+GPS_coord[0]+"LON:"+ GPS_coord[1]+"Num:"+GPS_numSat+"Fix:"+GPS_Fixed);
}
void ClickTabGPS()
{
  myPort.write("@sp"); 
  myPort.write("@msg"); 
  delay(100);
  myPort.clear();  // Clear input buffer up to here
  myPort.write("@ss");  
}
void ButtonGPS()
{
}
