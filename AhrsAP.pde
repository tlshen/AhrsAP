/*============================================================================*
 * O     O          __                   ______  __                           *
 *  \   /      /\  / /_      _    __    / /___/ / /_     _                    *
 *   [+]      /  \/ / \\    //__ / /__ / /____ / / \\   //                    *
 *  /   \    / /\  /   \\__// --/ /---/ /----// /   \\_//                     *
 * O     O  /_/  \/     \__/    \_\/ /_/     /_/ ____/_/                      *
 *                                                                            *
 *                                                                            *
 * Multi-Rotor controller application for Nuvoton Cortex M4 series            *
 *                                                                            *
 * Written by by T.L. Shen for Nuvoton Technology.                            *
 * tlshen@nuvoton.com/tzulan611126@gmail.com                                  *
 *                                                                            *
 *============================================================================*
 */
import controlP5.*;
ControlP5 cp5;
import processing.serial.*;
boolean firstSample = true;

float [] RwAcc = new float[3];
float [] Gyro = new float[3];        
float [] RwGyro = new float[3];       
float [] Awz = new float[3];          
float [] RwEst = new float[3];
short [] RwMag = new short[3];
float [] NormMag = new float[3];
float [] DegMag = new float[3];
float [] Quaternion = new float[4];
float [] QAxis = new float[4];
float [] MaxAcc = new float[3];        
float [] MaxGyro = new float[3];        
float [] MinAcc = new float[3];         
float [] MinGyro = new float[3];        
float [] Unit = new float[3];
float [] RwAccAvg = new float[3]; 
float [] GyroAvg = new float[3];
float [] GyroDeg = new float[3];
float [] GyroMoveDeg = new float[3];
float [] GyroMoveDegPrev = new float[3];
float StartAlt;
int lastTime = 0;
int interval = 0;
int GyroSteady = 0;
int GyroSteadyPrev = 0;
int tabN = 1;
float wGyro = 10.0;
float temperature;
float counter=0;
float Baro;
int lf = 10;
byte[] inBuffer = new byte[512];
boolean synched = false;
PFont font, pfont;
final int VIEW_SIZE_X = 900, VIEW_SIZE_Y = 800;
char mode = 0;
int i, j;
short[] Version = new short[2];
short[] Board = new short[2];
Button btnReportAHRS0,btnReportAHRS1;
void CP5_ComPortBox()
{
  loadButton=cp5.addButton("load")
     .setValue(0)
     .setPosition(240,120)
     .setSize(80,80)   
     .setColorBackground(#6060a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("default")
     .hide();
     ;
     
    saveButton=cp5.addButton("save")
     .setValue(0)
     .setPosition(370,120)
     .setSize(80,80)   
     .setColorBackground(#a08080)
     .setColorForeground(#d08080)
     .setColorActive(#f08080)
     .setColorCaptionLabel(#ffffff)
     .moveTo("default")
     .hide();
     ;
    //COM Gear Init */ 
    ListCom = cp5.addListBox("Copter COM")
         .setPosition(80,160)
         .setSize(120, 320)
         .setItemHeight(30)
         .setBarHeight(40)
         .setColorBackground(grey_)
         .moveTo("default")
         ;

    ListCom.captionLabel().set("Copter COM");
    ListCom.captionLabel().setColorBackground(grey_)
    ;
    
    for(int i=0;i<Serial.list().length;i++) {
      String pn = Serial.list()[i];
      println("pn"+i+":"+pn);
      ListBoxItem lbi = ListCom.addItem(pn,i); // addItem(name,value)
      lbi.setColorBackground(white_);
      ComListMax = i;
    }
    
    ListBoxItem lbi=ListCom.addItem("Close Com",++ComListMax);
    lbi.setColorBackground(orange_);
    txtWhichcom = cp5.addTextlabel("txtWhichcom0","No Port Selected",80,670)
    .setPosition(240,260)
    .moveTo("default")
    ;
    
    btnQConnect = cp5.addButton("bQCONN",0,80,650,100,19).setLabel("ReConnect").setColorBackground(red_)
    .setPosition(240,240)
    .moveTo("default")
    ;
}
void ButtonAHRSReport()
{
  int offY=100,offX=700;
   btnReportAHRS0=cp5.addButton("AHRS0")
     .setValue(0)
     .setPosition(offX,offY)
     .setSize(120,80)   
     .setColorBackground(#6060a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("default")
     .hide();
     
     btnReportAHRS1=cp5.addButton("AHRS1")
     .setValue(0)
     .setPosition(offX,offY+100)
     .setSize(120,80)   
     .setColorBackground(#6060a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("default")
     .hide();
}
public void addTabs(){
  if(cp5!=null) {
    
    cp5.addTab("default")
    .activateEvent(true)
    .setColorBackground(color(blue_))
    .setColorLabel(color(255))
    .setColorActive(color(green_))
    .setLabel("Port Setting")
    .setId(1);
    
    cp5.addTab("ATTITUDE")
    .activateEvent(true)
    .setLabel("ATTITUDE")
    .setId(2)
    .hide()
    ;
  
    cp5.addTab("PID")
    .activateEvent(true)
    .setColorBackground(color(blue_))
    .setColorLabel(color(255))
    .setColorActive(color(green_))
    .setLabel("PID")
    .hide()
    .setId(3);
    
    cp5.addTab("Velocity")
    .activateEvent(true)
    .setColorBackground(color(blue_))
    .setColorLabel(color(255))
    .setColorActive(color(green_))
    .setLabel("Velocity")
    .hide()
    .setId(4);
    
    cp5.addTab("Calibration")
    .activateEvent(true)
    .setColorBackground(color(blue_))
    .setColorLabel(color(255))
    .setColorActive(color(green_))
    .setLabel("Calibration")
    .hide()
    .setId(5);
    
    cp5.addTab("RC")
    .activateEvent(true)
    .setColorBackground(color(blue_))
    .setColorLabel(color(255))
    .setColorActive(color(green_))
    .setLabel("RC")
    .hide()
    .setId(6);
    
    cp5.addTab("GPS")
    .activateEvent(true)
    .setColorBackground(color(blue_))
    .setColorLabel(color(255))
    .setColorActive(color(green_))
    .setLabel("GPS")
    .hide()
    .setId(7);
  }
 }
 String ActiveTab="default";
public void controlEvent(ControlEvent theEvent) {
  if (theEvent.isTab()) { ActiveTab= theEvent.getTab().getName();  println("Switched to: "+ActiveTab);
    tabN= +theEvent.getTab().getId();
    if(tabN==2) {
      ClickTabAttitude();
    }
    else if(tabN==3) {
      ClickTabPID();
    }
    else if(tabN==4) {
      ClickTabVelocity();
    }
    else if(tabN==5) {
      ClickTabCalibration();
    }
    else if(tabN==6) {
      ClickTabRC();
    }
    else if(tabN==7) {
      ClickTabGPS();
    }
  }
   if (theEvent.isGroup()) if (theEvent.name()=="Copter COM") {
    InitSerial(theEvent.group().value());
    myPort = g_serial;
  }
}

void CP5_init()
{
  pfont = createFont("Consolas",16,false);
  ControlFont font = new ControlFont(pfont,241);
  cp5 = new ControlP5(this);
  addTabs();
  cp5.setFont(pfont);
  CP5_ComPortBox();
  ButtonAHRSReport();
  MotorBar();
  PID_BOX();
  CalibrationBox();
  ButtonVelocity();
  ButtonGPS();
  SliderRC();
  ButtonAHRSReport();
}
void setup()
{
    size(VIEW_SIZE_X, VIEW_SIZE_Y,OPENGL);
    frameRate(20); 

    font = loadFont("data/Tahoma-48.vlw");
    CP5_init();
    
    setupGPS();
}
void setupStack() {
  int VersionCount=100;
  println("Trying to setup and synch NuFusion...");
  do {

  myPort.clear(); 
  myPort.write("@h00"); 
  delay(200); 
  synched = readToken(myPort, "@HOOK00"); 
      println("@HOOK00");
  } while(!synched);
  
    println("Synched");
  myPort.write("@sp"); 
  myPort.write("@fb"); 
  /* Check Firmware Version */
  myPort.clear(); 
  delay(10); 
  do {
    myPort.write("@vf");
    delay(10);
    Version[0] = (short)readChar(myPort);
    if(Version[0]=='@')
      Version[1] = (short)readChar(myPort);
    VersionCount--;
    if(VersionCount==0) {
      Version[1] = 140;
      break;
    }
  } while (Version[0]!='@');
  println("Version:"+Version[1]);
  /* Check Board Version */
  VersionCount=10;
  myPort.clear(); 
  delay(10); 
  do {
    myPort.write("@vb");
    delay(10);
    Board[0] = (short)readChar(myPort);
    if(Board[0]=='$')
      Board[1] = (short)readChar(myPort);
    VersionCount--;
    if(VersionCount==0) {
      Board[1] = 140;
      break;
    }
  } while (Board[0]!='$');
  println("Board:"+Board[1]);
  
  myPort.write("@mq"); 
  myPort.write("@ss"); 
}

float readFloat(Serial s) {
  return Float.intBitsToFloat(s.read() + (s.read() << 8) + (s.read() << 16) + (s.read() << 24));
}
short readInt16(Serial s) {
  return (short)(s.read() + (s.read() << 8));
}
char readChar(Serial s) {
  return (char)(s.read());
}
int readInt32(Serial s) {
  return (s.read() + (s.read() << 8) + (s.read() << 16) + (s.read() << 24));
}

boolean readToken(Serial serial, String token) {

  if (myPort.available() < token.length())
    return false;
  
  for (int i = 0; i < token.length(); i++) {
    int k = myPort.read();
    //println("k:"+k);
    if (k != token.charAt(i))
      return false;
  }
  
  return true;
}


boolean Sync2NvtFly()
{
   if (!synched) {
     fill(#000000);
     text("Connecting to AHRS system ...", width/2-150, height/2, 200);
     setupStack(); 
     delay(1000);
     return false;
  }
  else {
    return true;
}
}

void draw()
{
  if(tabN==1) {
    DrawTabCOM();
  }
  else if(tabN==2) {    
    DrawTabAttitude();
  }
  else if(tabN==4) {
    DrawTabVelocity();
  }
  else if(tabN==3) {
    DrawTabPID();
  }
  else if(tabN==5) {
    DrawTabCalibration();
  }
  else if(tabN==6) {
    DrawTabRC();
  }
  else if(tabN==7) {
    DrawGPS();
  }
}
void keyPressed() {
  switch (key) {
    case '0': 
      mode = 0;
      myPort.write("@fb");
      myPort.write("@mq");
      myPort.write("@ss"); 
      break;
    case '1':  
      mode = 1;
      myPort.write("@cm"); 
      break;
    case '2':  
      mode = 1;
      myPort.write("@sp"); 
      break;
  }
}
