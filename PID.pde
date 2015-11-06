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
Slider[] Motor = new Slider[4];
Textlabel[] MotorLable = new Textlabel[4];
int[] MotorPower = new int[4];
float[][] GuiPID = new float[3][3];
float[][] GuiRatePID = new float[3][3];
float[] GuiAltHoldPID = new float[3];
color yellow_ = color(200, 200, 20), green_ = color(30, 180, 30), red_ = color(180, 30, 30), blue_ = color(50, 50, 100),
      grey_ = color(50, 50, 50),black_ = color(0, 0, 0),orange_ =color(200,128,0),white_ =color(100,100,100);
Button[] btnSetPID = new Button[3];   
Button btnStorePID; 
Button btnLoadPID;
Button btnResetPID; 
Button btnBaro;
Button btnVelocity;
int VelocityTabLength=6;
int StartCounter;
String[][] PID_NumBox = {
{"P_ROLL", "I_ROLL", "D_ROLL"},
{"P_PITCH", "I_PITCH", "D_PITCH"},
{"P_YAW", "I_YAW", "D_YAW"},};
String[][] RatePID_NumBox = {
{"RP_ROLL", "RI_ROLL", "RD_ROLL"},
{"RP_PITCH", "RI_PITCH", "RD_PITCH"},
{"RP_YAW", "RI_YAW", "RD_YAW"}};
String[] AltHoldPID_NumBox = {"P_ALTHOLD", "I_ALTHOLD", "D_ALTHOLD"};
void BoxYRP(int index)
{
  int offY=400,offX=50;
  int x=650,y1=600,hgap=15;
  
  cp5.addNumberbox(PID_NumBox[index][0])
     .setPosition(offX+index*90,70*1+offY)
     .setSize(80,40)
     .setRange(0,50)
     .setMultiplier(0.1) 
     .setDirection(Controller.HORIZONTAL) 
     .setValue(5.5)
     .hide()
     .moveTo("PID");
     
     cp5.addNumberbox(PID_NumBox[index][1])
     .setPosition(offX+index*90,70*2+offY)
     .setSize(80,40)
     .setRange(0,10)
     .setMultiplier(0.1) 
     .setDirection(Controller.HORIZONTAL)
     .setValue(0)
     .hide()
     .moveTo("PID");
     
     cp5.addNumberbox(PID_NumBox[index][2])
     .setPosition(offX+index*90,70*3+offY)
     .setSize(80,40)
     .setRange(0,50)
     .setMultiplier(0.1)
     .setDirection(Controller.HORIZONTAL)
     .setValue(0)
     .hide()
     .moveTo("PID");
}
void BoxRateYRP(int index)
{
   int offY=400,offX=350;
  int x=650,y1=600,hgap=15;
 
   cp5.addNumberbox(RatePID_NumBox[index][0])
     .setPosition(offX+index*90,70*1+offY)
     .setSize(80,40)
     .setRange(0,50)
     .setMultiplier(0.05)
     .setDirection(Controller.HORIZONTAL) 
     .setValue(13)
     .hide()
     .moveTo("PID");
     
     cp5.addNumberbox(RatePID_NumBox[index][1])
     .setPosition(offX+index*90,70*2+offY)
     .setSize(80,40)
     .setRange(0,200)
     .setMultiplier(0.1) 
     .setDirection(Controller.HORIZONTAL)
     .setValue(0)
     .hide()
     .moveTo("PID");
     
     cp5.addNumberbox(RatePID_NumBox[index][2])
     .setPosition(offX+index*90,70*3+offY)
     .setSize(80,40)
     .setRange(0,50)
     .setMultiplier(0.05) 
     .setDirection(Controller.HORIZONTAL)
     .setValue(0)
     .hide()
     .moveTo("PID");
}
void BoxAltHold(int index)
{
  int offY=400,offX=650;
  int x=650,y1=600,hgap=15;
 
   cp5.addNumberbox(AltHoldPID_NumBox[0])
     .setPosition(offX+index*90,70*1+offY)
     .setSize(80,40)
     .setRange(0,100)
     .setMultiplier(0.5)
     .setDirection(Controller.HORIZONTAL)
     .setValue(0.5)
     .hide()
     .moveTo("PID");
     
     cp5.addNumberbox(AltHoldPID_NumBox[1])
     .setPosition(offX+index*90,70*2+offY)
     .setSize(80,40)
     .setRange(0,5)
     .setMultiplier(0.01)
     .setDirection(Controller.HORIZONTAL) 
     .setValue(0.18)
     .hide()
     .moveTo("PID");
     
     cp5.addNumberbox(AltHoldPID_NumBox[2])
     .setPosition(offX+index*90,70*3+offY)
     .setSize(80,40)
     .setRange(0,1000)
     .setMultiplier(1) 
     .setDirection(Controller.HORIZONTAL)
     .setValue(0)
     .hide()
     .moveTo("PID");
}
void ButtonPID()
{
  int offY=700,offX=110;
   btnSetPID[0]=cp5.addButton("SetPID")
     .setValue(0)
     .setPosition(offX,offY)
     .setSize(120,80)   
     .setColorBackground(#6060a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("PID")
     .hide();
     
     btnSetPID[1]=cp5.addButton("SetRatePID")
     .setValue(0)
     .setPosition(offX+310,offY)
     .setSize(120,80)   
     .setColorBackground(#6060a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("PID")
     .hide();
     
     btnSetPID[2]=cp5.addButton("SetAltHoldPID")
     .setValue(0)
     .setPosition(offX+520,offY)
     .setSize(120,80)   
     .setColorBackground(#6060a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("PID")
     .hide();
}
void ButtonLSPID()
{
  int offY=100,offX=700;
   btnLoadPID=cp5.addButton("LoadPID")
     .setValue(0)
     .setPosition(offX,offY)
     .setSize(120,80)   
     .setColorBackground(#6060a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("PID")
     .hide();
     
     btnStorePID=cp5.addButton("StorePID")
     .setValue(0)
     .setPosition(offX,offY+100)
     .setSize(120,80)   
     .setColorBackground(#6060a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("PID")
     .hide();
     
     btnResetPID=cp5.addButton("ResetPID")
     .setValue(0)
     .setPosition(offX,offY+200)
     .setSize(120,80)   
     .setColorBackground(#6060a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("PID")
     .hide();
}
void UpdatePID() {
  String token; 

  myPort.write("@sp");
  
  for(int i=0;i<3;i++) {
   GuiPID[i][0] = (float)((int)(cp5.controller(PID_NumBox[i][0]).getValue()*1000))/1000;
   GuiPID[i][1] = (float)((int)(cp5.controller(PID_NumBox[i][1]).getValue()*1000))/1000;
   GuiPID[i][2] = (float)((int)(cp5.controller(PID_NumBox[i][2]).getValue()*1000))/1000;
  }
  token="@pprp"+GuiPID[0][0]+'\r';myPort.write(token);delay(100);println(token);
  token="@ppri"+GuiPID[0][1]+'\r';myPort.write(token);delay(100);println(token);
  token="@pprd"+GuiPID[0][2]+'\r';myPort.write(token);delay(100);println(token);
  token="@pppp"+GuiPID[1][0]+'\r';myPort.write(token);delay(100);println(token);
  token="@pppi"+GuiPID[1][1]+'\r';myPort.write(token);delay(100);println(token);
  token="@pppd"+GuiPID[1][2]+'\r';myPort.write(token);delay(100);println(token);
  token="@ppyp"+GuiPID[2][0]+'\r';myPort.write(token);delay(100);println(token);
  token="@ppyi"+GuiPID[2][1]+'\r';myPort.write(token);delay(100);println(token);
  token="@ppyd"+GuiPID[2][2]+'\r';myPort.write(token);delay(100);println(token);
  delay(100);
  myPort.clear();
  myPort.write("@ss");

}
void UpdateRatePID() {
  String token; 
  //myPort.write("@sp");
  for(int i=0;i<3;i++) {
    GuiRatePID[i][0] = (float)((int)(cp5.controller(RatePID_NumBox[i][0]).getValue()*1000))/1000;
    GuiRatePID[i][1] = (float)((int)(cp5.controller(RatePID_NumBox[i][1]).getValue()*1000))/1000;
    GuiRatePID[i][2] = (float)((int)(cp5.controller(RatePID_NumBox[i][2]).getValue()*1000))/1000;
  }
  token="@prrp"+GuiRatePID[0][0]+'\r'+'\r';myPort.write(token);delay(200);println(token);
  token="@prri"+GuiRatePID[0][1]+'\r'+'\r';myPort.write(token);delay(200);println(token);
  token="@prrd"+GuiRatePID[0][2]+'\r'+'\r';myPort.write(token);delay(200);println(token);
  token="@prpp"+GuiRatePID[1][0]+'\r'+'\r';myPort.write(token);delay(200);println(token);
  token="@prpi"+GuiRatePID[1][1]+'\r'+'\r';myPort.write(token);delay(200);println(token);
  token="@prpd"+GuiRatePID[1][2]+'\r'+'\r';myPort.write(token);delay(200);println(token);
  token="@pryp"+GuiRatePID[2][0]+'\r'+'\r';myPort.write(token);delay(200);println(token);
  token="@pryi"+GuiRatePID[2][1]+'\r'+'\r';myPort.write(token);delay(200);println(token);
  token="@pryd"+GuiRatePID[2][2]+'\r'+'\r';myPort.write(token);delay(200);println(token);
  //delay(10);
  //myPort.clear();
  //myPort.write("@ss");
  
}
void UpdateAltHoldPID() {
  String token; 
  myPort.write("@sp");
  for(int i=0;i<3;i++) {
    GuiAltHoldPID[i] = (float)((int)(cp5.controller(AltHoldPID_NumBox[i]).getValue()*1000))/1000;
  }
  token="@pap"+GuiAltHoldPID[0]+'\r'+'\r';myPort.write(token);delay(100);println(token);
  token="@pai"+GuiAltHoldPID[1]+'\r'+'\r';myPort.write(token);delay(100);println(token);
  token="@pad"+GuiAltHoldPID[2]+'\r'+'\r';myPort.write(token);delay(100);println(token);
  
  delay(100);
  myPort.clear();
  myPort.write("@ss");
  
}

void DeviceLoadPID() 
{
  String token; 
  myPort.write("@sp");
  delay(100);
  myPort.clear();
  myPort.write("@pl");
  delay(100);
  myPort.write("@mpp");
  delay(100);
  myPort.write("@ss");
  while(!readPID());
  println("-----------------------");
  for(int i=0;i<3;i++) {
   cp5.controller(PID_NumBox[i][0]).setValue(GuiPID[i][0]);
   cp5.controller(PID_NumBox[i][1]).setValue(GuiPID[i][1]);
   cp5.controller(PID_NumBox[i][2]).setValue(GuiPID[i][2]);
  }
  myPort.write("@sp");
  delay(100);
  myPort.clear();
  myPort.write("@mpr");
  delay(100);
  myPort.write("@ss");
  while(!readRatePID());
  
  for(int i=0;i<3;i++) {
   cp5.controller(RatePID_NumBox[i][0]).setValue(GuiRatePID[i][0]);
   cp5.controller(RatePID_NumBox[i][1]).setValue(GuiRatePID[i][1]);
   cp5.controller(RatePID_NumBox[i][2]).setValue(GuiRatePID[i][2]);
  }
  
  myPort.write("@sp");
  delay(100);
  myPort.clear();
  myPort.write("@mpa");
  delay(100);
  myPort.write("@ss");
  while(!readAltHoldPID());
  
  for(int i=0;i<3;i++) {
   cp5.controller(AltHoldPID_NumBox[i]).setValue(GuiAltHoldPID[i]);
  }
  
  myPort.write("@sp");
  delay(100);
  myPort.clear();
  myPort.write("@mm");
  delay(100);
  myPort.write("@ss");
}
void DeviceStorePID() {
  myPort.write("@ps");
}
void DeviceResetPID() {
  myPort.write("@bep");
}
public void SetPID(int theValue) {
  if(synched)
    UpdatePID();
}
public void SetRatePID(int theValue) {
  if(synched)
    UpdateRatePID();
}
public void SetAltHoldPID(int theValue) {
  if(synched)
    UpdateAltHoldPID();
}
public void LoadPID(int theValue) {
  if(synched)
    DeviceLoadPID();
}
public void StorePID(int theValue) {
  if(synched)
    DeviceStorePID();
}
public void ResetPID(int theValue) {
  if(synched)
    DeviceResetPID();
}
boolean readRatePID()
{
  int i;
  while (myPort.available() >= 36)
  { 
     GuiRatePID[0][0] = readFloat(myPort);
     GuiRatePID[0][1] = readFloat(myPort);
     GuiRatePID[0][2] = readFloat(myPort);
     GuiRatePID[1][0] = readFloat(myPort);
     GuiRatePID[1][1] = readFloat(myPort);
     GuiRatePID[1][2] = readFloat(myPort);
     GuiRatePID[2][0] = readFloat(myPort);
     GuiRatePID[2][1] = readFloat(myPort);
     GuiRatePID[2][2] = readFloat(myPort);
     println("0:"+GuiRatePID[0][0]+" 1:"+GuiRatePID[0][1]+" 2:"+GuiRatePID[0][2]);
     return true;
   }
   return false;
}
boolean readAltHoldPID()
{
  int i;
  while (myPort.available() >= 12)
  { 
     GuiAltHoldPID[0] = readFloat(myPort);
     GuiAltHoldPID[1] = readFloat(myPort);
     GuiAltHoldPID[2] = readFloat(myPort);
     
      println("0:"+GuiAltHoldPID[0]+" 1:"+GuiAltHoldPID[1]+" 2:"+GuiAltHoldPID[2]);
      return true;
    }
    return false;
}
void UpdateMotor()
{
  if(MotorPower[0]>0) {
    Motor[0].setValue(MotorPower[0]);
    Motor[1].setValue(0);
  }
  else {
    Motor[1].setValue(-MotorPower[0]);
    Motor[0].setValue(0);
  }
  if(MotorPower[1]<0) {
    Motor[3].setValue(-MotorPower[1]);
    Motor[2].setValue(0);
  }
  else {
    Motor[3].setValue(0);
    Motor[2].setValue(MotorPower[1]);
  }
}
void MotorBar()
{
  int MotorBar_W=30, MotorBar_H=100, MotorBar_X=210, MotorBar_Y=50, MotorText=20, MotorMin=1090,MotorMax=2000,MotorBar_PitchX=300,MotorBar_PitchY=250;
 
  Motor[3] = cp5.addSlider("Motor4",MotorMin,MotorMax,0,MotorBar_X,MotorBar_Y,MotorBar_W,MotorBar_H).setDecimalPrecision(0).setLabel("").hide().moveTo("PID");
  MotorLable[3] = cp5.addTextlabel("M4","M4",MotorBar_X,MotorBar_Y-MotorText).hide().moveTo("PID");
  Motor[0] = cp5.addSlider("Motor1",MotorMin,MotorMax,0,MotorBar_X+MotorBar_PitchX,MotorBar_Y,MotorBar_W,MotorBar_H).setDecimalPrecision(0).setLabel("").hide().moveTo("PID");
  MotorLable[0] = cp5.addTextlabel("M1","M1",MotorBar_X+MotorBar_PitchX,MotorBar_Y-MotorText).hide().moveTo("PID");
  Motor[2] = cp5.addSlider("Motor3",MotorMin,MotorMax,0,MotorBar_X,MotorBar_Y+MotorBar_PitchY,MotorBar_W,MotorBar_H).setDecimalPrecision(0).setLabel("").hide().moveTo("PID");
  MotorLable[2] = cp5.addTextlabel("M3","M3",MotorBar_X,MotorBar_Y+MotorBar_PitchY-MotorText).hide().moveTo("PID");
  Motor[1] = cp5.addSlider("Motor2",MotorMin,MotorMax,0,MotorBar_X+MotorBar_PitchX,MotorBar_Y+MotorBar_PitchY,MotorBar_W,MotorBar_H).setDecimalPrecision(0).setLabel("").hide().moveTo("PID");
  MotorLable[1] = cp5.addTextlabel("M2","M2",MotorBar_X+MotorBar_PitchX,MotorBar_Y+MotorBar_PitchY-MotorText).hide().moveTo("PID");
}
void PID_BOX()
{
  BoxYRP(0);
  BoxYRP(1);
  BoxYRP(2);
  BoxRateYRP(0);
  BoxRateYRP(1);
  BoxRateYRP(2);
  BoxAltHold(0);
  ButtonPID();
  ButtonLSPID();
}
void readMotors()
{
  int i;
  while (myPort.available() >= 8)
  { 
    MotorPower[0] = readInt16(myPort);
    MotorPower[1] = readInt16(myPort);
    MotorPower[2] = readInt16(myPort);
    MotorPower[3] = readInt16(myPort);
    println("Motor:"+MotorPower[0]+MotorPower[1]);
    
  }
}
boolean readPID()
{
  int i;
  while (myPort.available() >= 36)
  { 
    GuiPID[0][0] = readFloat(myPort);
    GuiPID[0][1] = readFloat(myPort);
    GuiPID[0][2] = readFloat(myPort);
    GuiPID[1][0] = readFloat(myPort);
    GuiPID[1][1] = readFloat(myPort);
    GuiPID[1][2] = readFloat(myPort);
    GuiPID[2][0] = readFloat(myPort);
    GuiPID[2][1] = readFloat(myPort);
    GuiPID[2][2] = readFloat(myPort);
    println("0:"+GuiPID[0][0]+" 1:"+GuiPID[0][1]+" 2:"+GuiPID[0][2]);
    return true;
    }
    return false;
}

void buildCopterShape()
{
    PImage img = loadImage("compass_image/quadcoptor256.jpg");
    noStroke();
    beginShape(QUADS);
    fill(#00ff00);
    texture(img);
    vertex(-25, -25, 20, 0, 0);
    vertex(25, -25, 20, 256, 0);
    vertex(25, 25, 20, 256, 256);
    vertex(-25, 25, 20, 0 ,256);
    endShape();
}

void drawCopter()
{
    pushMatrix();
    translate(400, 250, 0);
    scale(4, 4, 4);
    buildCopterShape();
    popMatrix();
}
void DrawTabPID() 
{
  background(0);
  noFill();
  readMotors();
  UpdateMotor();
  drawCopter();
}
void ClickTabPID()
{
  if(Board[1]==145) {
    MotorLable[0].setText("MR_CW");
    MotorLable[1].setText("MR_CCW");
    MotorLable[2].setText("ML_CW");
    MotorLable[3].setText("ML_CCW");
    Motor[0].setMax(1000);
    Motor[1].setMax(1000);
    Motor[2].setMax(1000);
    Motor[3].setMax(1000);
    Motor[0].setMin(0);
    Motor[1].setMin(0);
    Motor[2].setMin(0);
    Motor[3].setMin(0);
  }
  Motor[0].show();
  MotorLable[0].show();
  Motor[1].show();
  MotorLable[1].show();
  Motor[2].show();
  MotorLable[2].show();
  Motor[3].show();
  MotorLable[3].show();
  println("in PID tab");
  background(0);
  DeviceLoadPID();
  myPort.write("@st");
  myPort.write("@mm"); 
  delay(100);
  myPort.clear();
  myPort.write("@st"); 
  cp5.getController(PID_NumBox[0][0]).show();
  cp5.getController(PID_NumBox[1][0]).show();
  cp5.getController(PID_NumBox[2][0]).show();
  cp5.getController(PID_NumBox[0][1]).show();
  cp5.getController(PID_NumBox[1][1]).show();
  cp5.getController(PID_NumBox[2][1]).show();
  cp5.getController(PID_NumBox[0][2]).show();
  cp5.getController(PID_NumBox[1][2]).show();
  cp5.getController(PID_NumBox[2][2]).show();
  cp5.getController(RatePID_NumBox[0][0]).show();
  cp5.getController(RatePID_NumBox[1][0]).show();
  cp5.getController(RatePID_NumBox[2][0]).show();
  cp5.getController(RatePID_NumBox[0][1]).show();
  cp5.getController(RatePID_NumBox[1][1]).show();
  cp5.getController(RatePID_NumBox[2][1]).show();
  cp5.getController(RatePID_NumBox[0][2]).show();
  cp5.getController(RatePID_NumBox[1][2]).show();
  cp5.getController(RatePID_NumBox[2][2]).show();
  cp5.getController(AltHoldPID_NumBox[0]).show();
  cp5.getController(AltHoldPID_NumBox[1]).show();
  cp5.getController(AltHoldPID_NumBox[2]).show();
  btnSetPID[0].show();
  btnSetPID[1].show();
  btnSetPID[2].show();
  btnLoadPID.show();
  btnStorePID.show();
  btnResetPID.show();
  cursor(ARROW);
}
