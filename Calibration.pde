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
 Slider[] MagCalibrateBar = new Slider[2];
 Textlabel[] MagCalibrateLable = new Textlabel[2];
 int[] RawData = new int[4];
 float[] Euler = new float[4];
 int RawCount,QF,SideAcc;
 boolean Calibrating,CalibratingAcc;
 boolean Eulering;
 Button btnMagCalibrate,btnMagReset; 
 Button btnAccCalibrate,btnAccReset,btnAccStop; 
public void MagCalibrate(int theValue) {
  println("->MagCalibrate");
  RawData[3] = 0;
  myPort.write("@sp");
  myPort.write("@cm"); 
  delay(100);
  myPort.clear();
  Calibrating = true;
  Eulering = false;
}
public void MagReset(int theValue) {
  println("->MagReset");
  RawData[3] = 0;
  myPort.write("@sp");
  myPort.write("@bem"); 
  delay(100);
  myPort.clear();
  myPort.write("@ss");
}
 void ButtonMagCalibrate()
{
  int offY=230,offX=40;
   println("->ButtonCalibrate");
     RawData[3] = 0;
     btnMagCalibrate=cp5.addButton("MagCalibrate")
     .setValue(0)
     .setPosition(offX,offY+100)
     .setSize(120,80)   
     .setColorBackground(#60a0a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("Calibration")
     .hide();
}
void ButtonMagReset()
{
  int offY=230,offX=200;
   println("->ButtonMagReset");
     RawData[3] = 0;
     btnMagReset=cp5.addButton("MagReset")
     .setValue(0)
     .setPosition(offX,offY+100)
     .setSize(90,80)   
     .setColorBackground(#a060a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("Calibration")
     .hide();
}
public void AccCalibrate(int theValue) {
  println("->AccCalibrate");
  String CAX;
  CAX = "@ca" + SideAcc;
  myPort.write("@sp");
  myPort.write(CAX); 
  delay(100);
  myPort.clear();
  CalibratingAcc = true;
  Eulering = false;
}
public void AccReset(int theValue) {
  println("->AccReset");
  myPort.write("@sp");
  myPort.write("@bea"); 
  delay(100);
  myPort.clear();
  myPort.write("@ss");
}
public void AccStop(int theValue) {
  println("->AccStop");
  SideAcc = 0;
  CalibratingAcc = false;
  StartEuler();
}
 void ButtonAccCalibrate()
{
  int offY=230,offX=300+160;
   println("->ButtonAccCalibrate");
     btnAccCalibrate=cp5.addButton("AccCalibrate")
     .setValue(0)
     .setPosition(offX,offY+100)
     .setSize(120,80)   
     .setColorBackground(#60a0a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("Calibration")
     .hide();
}
void ButtonAccReset()
{
  int offY=230,offX=300 + 160*3 - 30;
   println("->ButtonAccReset");
     btnAccReset=cp5.addButton("AccReset")
     .setValue(0)
     .setPosition(offX,offY+100)
     .setSize(90,80)   
     .setColorBackground(#a060a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("Calibration")
     .hide();
}
void ButtonAccStop()
{
  int offY=230,offX=300 + 160*2;
   println("->ButtonAccStop");
     btnAccStop=cp5.addButton("AccStop")
     .setValue(0)
     .setPosition(offX,offY+100)
     .setSize(90,80)   
     .setColorBackground(#b0b080)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("Calibration")
     .hide();
}
void MagCalBar() 
{
int CalBar_W=30, CalBar_H=200, CalBar_X=210, CalBar_Y=50, CalText=210, CalMin=0,CalMax=100,CalBar_PitchX=300,CalBar_PitchY=250;
  MagCalibrateBar[0] = cp5.addSlider("SampleCount",CalMin,CalMax,0,CalBar_X,CalBar_Y,CalBar_W,CalBar_H).setDecimalPrecision(0).setLabel("").hide().moveTo("Calibration");
  MagCalibrateLable[0] = cp5.addTextlabel("Count","Mag Sample%",CalBar_X-50,CalBar_Y+CalText).hide().moveTo("Calibration");
 }
void CalibrationBox()
{
  println("->CalibrationBox");
   ButtonMagCalibrate();
   ButtonMagReset();
   MagCalBar();
   ButtonAccCalibrate();
   ButtonAccReset();
   ButtonAccStop();
}

void readMagCalibrate()
{
 int i;
 char End;
 if(Calibrating) {
    while (myPort.available() >= 6)
    { 
      println("->readMagCalibrate"+RawData[3]);
      RawData[0] = readInt16(myPort);
        RawData[1] = readInt16(myPort);
        RawData[2] = readInt16(myPort);
        
          RawData[3]++;
    }
    if(RawData[3]>=120) {
      Calibrating = false;
      End = readChar(myPort);
      QF = (int)readChar(myPort);
      println("End:"+End+",QF:"+QF);  
      delay(2000);
      StartEuler();
         
    }
 }
 /*else {
   if (myPort.available()>0)
   readInt16(myPort);
 }*/
}
void readAccCalibrate()
{
 char End;
 if(CalibratingAcc) {
    if (myPort.available()>0)
    { 
      End = readChar(myPort);
      println("readAccCalibrate"+End);
      if(End == 'd') {
        SideAcc = 0;
        CalibratingAcc = false;
        StartEuler();
      }
      else {
        SideAcc++;
      }
      
    }      
  }
}
void buildCompassShape()
{
    //box(60, 10, 40);
    PImage img = loadImage("compass_image/Compass-iPhone-icon1.jpg");
    noStroke();
    beginShape(QUADS);

    //Z+ (绘图?��?)
    fill(#00ff00);
    texture(img);
    vertex(-25, -25, 20, 0, 0);
    vertex(25, -25, 20, 256, 0);
    vertex(25, 25, 20, 256, 256);
    vertex(-25, 25, 20, 0 ,256);

    endShape();
}

void drawCompass()
{
    pushMatrix();
    translate(180, 550, 0);
    scale(4, 4, 4);

    //rotateX(HALF_PI * -RwEst[0]);
    rotateZ(Euler[2]/180*PI);


    //rotate(QAxis[0],-QAxis[2],-QAxis[3],-QAxis[1]);

    buildCompassShape();

    popMatrix();
}
void UpdateMagCalibrateBar()
{
  MagCalibrateBar[0].setValue(int(((float)RawData[3]/120)*100));
}
void readEuler()
{
 int i;
 char Start;
 if(Eulering) {
    while (myPort.available() >= 17)
    { 
      Start = readChar(myPort);
      if(Start!='@') return;
      Euler[0] = readFloat(myPort);
      Euler[1] = readFloat(myPort);
      Euler[2] = readFloat(myPort);
      Euler[3] = readFloat(myPort);
    }
 }
}
void readDummy()
{

 if(!Eulering && !Calibrating) {
    while (myPort.available() >= 16)
    { 
      println("->readDummy");
      Euler[0] = readFloat(myPort);
      Euler[1] = readFloat(myPort);
      Euler[2] = readFloat(myPort);
      Euler[3] = readFloat(myPort);
    }
 }
}
void StartEuler()
{
  myPort.write("@sp");
      myPort.write("@me"); 
       myPort.clear();
      delay(500);
       myPort.clear();
     
      myPort.write("@ss");
      Eulering = true;
   
}
void buildLineShape()
{
    noStroke();
    beginShape(QUADS);

    fill(#dddddd);
    vertex(-10, -350, 20);
    vertex(10, -350, 20);
    vertex(10, 350, 20);
    vertex(-10, 350, 20);

    endShape();
}
void drawLine()
{
    pushMatrix();
    translate(400, 400, 0);


    buildLineShape();

    popMatrix();
}
void DrawTabCalibration() 
{
  //println("->DrawTabCalibration");
  background(0);
  noFill();
  readMagCalibrate();
  readAccCalibrate();
  UpdateMagCalibrateBar();
  readEuler();
  background(#000000);
  fill(#ffffff);
  textFont(font, 25);
  text("RwMag:"+ RawData[3]+"\n" + RawData[0] + "\n" + RawData[1] + "\n" + RawData[2], 40, 80);
  if(QF>20)
    fill(#ff0000);
  else
    fill(#ffffff);
  text("Quality:"+"\n" + QF, 40, 230);
  if(Euler[2]>10||Euler[2]<-10)
    fill(#ff0000);
  else
    fill(#ffffff);
  
  text("North:"+ (int)Euler[2], 80, 750);
  
  if(Euler[0]>1||Euler[0]<-1||Euler[1]>1||Euler[1]<-1)
    fill(#ff0000);
  else
    fill(#ffffff);
  text("X:"+ Euler[0], 560, 550);
  text("Y:"+ Euler[1], 560, 600);
  
  if(Euler[3]>2||Euler[3]<-2)
    fill(#ff0000);
  else
    fill(#ffffff);
  text("B:"+ Euler[3], 560, 650);
  
  textFont(font, 30);
  fill(#ffffff);
  text("FACE:", 480, 150);
   if(SideAcc==0)
    fill(#ffffff);
  else
    fill(#ff00ff);
  textFont(font, 200);
  text(SideAcc, 600, 200);
  drawCompass();
  drawLine();
  
  fill(#ffffff);
  textFont(font, 20);
}
void ClickTabCalibration()
{
  println("->ClickTabCalibration");
  background(0);
  

  MagCalibrateBar[0].show();
  MagCalibrateLable[0].show();

  btnMagCalibrate.show();
  btnMagReset.show();
  StartEuler();
  btnAccCalibrate.show(); 
  btnAccReset.show();
  btnAccStop.show();
  cursor(ARROW);
}
