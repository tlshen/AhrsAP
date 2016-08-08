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
 boolean Texture = true;
 Button btnTextureSwitch; 
 public void TextureSwitch(int theValue) {
  println("->TextureSwitch");
  if(Texture)
    Texture = false;
  else
    Texture = true;  
}
void ButtonTextureSwitch()
{
  int offY=700,offX=200;
   println("->ButtonTextureSwitch");
     btnTextureSwitch=cp5.addButton("TextureSwitch")
     .setValue(0)
     .setPosition(offX,offY)
     .setSize(130,40)   
     .setColorBackground(#a060a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("ATTITUDE")
     .hide();
}
void buildOldBoxShape()
{
    PImage img = loadImage("Form_3Dcuboid/Bottom.png");
    noStroke();
    beginShape(QUADS);

    //Z+
    fill(#00ff00);
    //texture(img);
    vertex(-30, -5, 20, 0, 0);
    vertex(30, -5, 20, 1066, 0);
    vertex(30, 5, 20, 1066, 712);
    vertex(-30, 5, 20, 0 ,712);

    //Z-
    fill(#0000ff);
    vertex(-30, -5, -20);
    vertex(30, -5, -20);
    vertex(30, 5, -20);
    vertex(-30, 5, -20);

    //X-
    fill(#ff0000);
    vertex(-30, -5, -20);
    vertex(-30, -5, 20);
    vertex(-30, 5, 20);
    vertex(-30, 5, -20);

    //X+
    fill(#ffff00);
    vertex(30, -5, -20);
    vertex(30, -5, 20);
    vertex(30, 5, 20);
    vertex(30, 5, -20);

    //Y-
    fill(#ff00ff);
    vertex(-30, -5, -20);
    vertex(30, -5, -20);
    vertex(30, -5, 20);
    vertex(-30, -5, 20);

    //Y+
    fill(#00ffff);
    vertex(-30, 5, -20);
    vertex(30, 5, -20);
    vertex(30, 5, 20);
    vertex(-30, 5, 20);

    endShape();
}
void buildBoxShape()
{
    PImage imgZP = loadImage("Form_3Dcuboid/AHRS_Front.jpg");
    PImage imgZN = loadImage("Form_3Dcuboid/AHRS_Back.jpg");
    PImage imgXP = loadImage("Form_3Dcuboid/AHRS_Left.jpg");
    PImage imgXN = loadImage("Form_3Dcuboid/AHRS_Right.jpg");
    //PImage imgYP = loadImage("Form_3Dcuboid/Front.png");
    PImage imgYP = loadImage("Form_3Dcuboid/AHRS_Buttom.jpg");
    //PImage imgYN = loadImage("Form_3Dcuboid/Back.png");
    PImage imgYN = loadImage("Form_3Dcuboid/AHRS_Top.jpg");
    int W = 20;
    int L = 20;
    int H = 5;
    noStroke();
    
    //Z+
    beginShape(QUADS);
    fill(#00ff00);
    texture(imgZP);
    vertex(-W, -H, L, 0, 0);
    vertex(W, -H, L, 1066, 0);
    vertex(W, H, L, 1066, 357);
    vertex(-W, H, L, 0 ,357);
    endShape();
    
    //Z-
    beginShape(QUADS);
    fill(#0000ff);
    texture(imgZN);
    vertex(-W, -H, -L, 1066, 0);
    vertex(W, -H, -L, 0, 0);
    vertex(W, H, -L, 0, 357);
    vertex(-W, H, -L, 1066 ,357);
    endShape();
    
    //X-
    beginShape(QUADS);
    fill(#ff0000);
    texture(imgXN);
    vertex(-W, -H, -L, 0, 0);
    vertex(-W, -H, L, 712, 0);
    vertex(-W, H, L, 712, 357);
    vertex(-W, H, -L, 0 ,357);
    endShape();

    //X+
    beginShape(QUADS);
    fill(#ffff00);
    texture(imgXP);
    /*vertex(W, -H, -L, 0, 0);
    vertex(W, -H, L, 712, 0);
    vertex(W, H, L, 712, 357);
    vertex(W, H, -L, 0 ,357);*/
    vertex(W, -H, -L, 712, 0);
    vertex(W, -H, L, 0, 0);
    vertex(W, H, L, 0, 357);
    vertex(W, H, -L, 712 ,357);
    endShape();

    //Y-
    beginShape(QUADS);
    fill(#ff00ff);
    texture(imgYN);
    vertex(-W, -H, -L, 0, 0);
    vertex(W, -H, -L, 363, 0);
    vertex(W, -H, L, 363, 363);
    vertex(-W, -H, L, 0 ,363);
    endShape();

    //Y+
    beginShape(QUADS);
    fill(#00ffff);
    texture(imgYP);
    vertex(-W, H, -L, 0, 0);
    vertex(W, H, -L, 0, 363);
    vertex(W, H, L, 363, 363);
    vertex(-W, H, L, 363 ,0);
    endShape();
}
void drawCube()
{
    pushMatrix();
    translate(400, 400, 0);
    scale(4, 4, 4);
    rotateY(PI);
    rotate(QAxis[0],-QAxis[2],-QAxis[3],-QAxis[1]);
    if(Texture)
      buildBoxShape();  
    else
      buildOldBoxShape();
    popMatrix();
}
void buildBackgroundShape()
{
    PImage img = loadImage("Form_3Dcuboid/AHRS_Background.jpg");
    noStroke();
    beginShape(QUADS);

    //Z+ (绘图?��?)
    fill(#00ff00);
    texture(img);
    vertex(0, 0, 0, 0, 0);
    vertex(0, 900, 0, 0, 900);
    vertex(900, 800, 0, 900, 800);
    vertex(800, 0, 0, 800 ,0);

    endShape();
}
void drawBackground()
{
    pushMatrix();
    buildBackgroundShape();
    popMatrix();
}
void readSensors()
{
  int i;
  char Start;
  if(mode==0) {
    while (myPort.available() >= 17)
    { 
      float receipt_norm;
      Start = readChar(myPort);
      if(Start!='@') return;
      Quaternion[0] = readFloat(myPort);
      Quaternion[1] = readFloat(myPort);
      Quaternion[2] = readFloat(myPort);
      Quaternion[3] = readFloat(myPort);
      
      for(i=0;i<3;i++) {
        if(RwAcc[i]>MaxAcc[i])
          MaxAcc[i]=RwAcc[i];
        if(Gyro[i]>MaxGyro[i])
          MaxGyro[i]=Gyro[i];
        if(RwAcc[i]<MinAcc[i])
          MinAcc[i]=RwAcc[i];
        if(Gyro[i]<MinGyro[i])
          MinGyro[i]=Gyro[i];
        if(counter==50)
        {
          MaxAcc[i]=-1;
          MaxGyro[i]=-100;
          MinAcc[i]=1;
          MinGyro[i]=100;
        }
      }
      Unit[0]=sqrt(RwAcc[0]*RwAcc[0]+RwAcc[1]*RwAcc[1]+RwAcc[2]*RwAcc[2]);
      
      for(i=0;i<3;i++) {
        RwAccAvg[i]=(9*RwAccAvg[i]+RwAcc[i])/10;
        GyroAvg[i]=(49*GyroAvg[i]+Gyro[i])/50;
      }
      receipt_norm = sqrt(RwMag[0]*RwMag[0]+RwMag[1]*RwMag[1]+RwMag[2]*RwMag[2]);
      for(i=0;i<3;i++) {
        NormMag[i]=RwMag[i]/receipt_norm;
      }
      if(counter<50)
        counter++;
      else
        counter=0;
    }
  }
  else if(mode==1) {
    while (myPort.available() >= 6)
    { 
      RwMag[0] = readInt16(myPort);
      RwMag[1] = readInt16(myPort);
      RwMag[2] = readInt16(myPort);
    }
  }
}

void CalGyroDegree()
{
  if((GyroSteadyPrev==1)&&(GyroSteady==0)) {
    
  }
  else if((GyroSteadyPrev==0)&&(GyroSteady==1)) {
    GyroMoveDeg[0]=GyroDeg[0] - GyroMoveDegPrev[0];
    GyroMoveDeg[1]=GyroDeg[1] - GyroMoveDegPrev[1];
    GyroMoveDeg[2]=GyroDeg[2] - GyroMoveDegPrev[2];
    GyroMoveDegPrev[0] = GyroDeg[0];
    GyroMoveDegPrev[1] = GyroDeg[1];
    GyroMoveDegPrev[2] = GyroDeg[2];
  }
  GyroSteadyPrev = GyroSteady;
}
void DrawTabAttitude()
{
  readSensors();
  CalGyroDegree();
  QAxis[0]=2*acos(Quaternion[0]);
  QAxis[1]=-Quaternion[1]/sin(QAxis[0]/2);
  QAxis[2]=-Quaternion[2]/sin(QAxis[0]/2);
  QAxis[3]=-Quaternion[3]/sin(QAxis[0]/2);
 
  //background(#000000);
  //fill(#ffffff);
  textFont(font, 20);
  /*text("RwAcc (G):\n" + RwAcc[0] + "\n" + RwAcc[1] + "\n" + RwAcc[2] + "\ninterval: " + interval, 20, 50);
  text("Gyro (°/s):\n" + Gyro[0] + "\n" + Gyro[1] + "\n" + Gyro[2], 220, 50);
  text("Awz (°):\n" + Awz[0] + "\n" + Awz[1] + "\n" + Awz[2] , 420, 50);
  text("Temperature (°C):\n" + temperature , 20, 180);
  text("RwEst :\n" + RwEst[0] + "\n" + RwEst[1] + "\n" + RwEst[2], 220, 180);
  text("RwMag (Guess):\n" + RwMag[0] + "\n" + RwMag[1] + "\n" + RwMag[2], 20, 310);
  text("DegMag (°):\n" + DegMag[0] + "\n" + DegMag[1] + "\n" + DegMag[2], 20, 440);
  text("NormMag (°):\n" + NormMag[0] + "\n" + NormMag[1] + "\n" + NormMag[2], 20, 570);
  text("GyroRange (°/s):\n" + MinGyro[0]+"~"+ MaxGyro[0] + "\n"+ MinGyro[1]+"~"+MaxGyro[1] + "\n"+ MinGyro[2]+"~"+ MaxGyro[2], 620, 50);
  text("AccRange (°/s):\n" + MinAcc[0]+"~"+ MaxAcc[0] + "\n"+ MinAcc[1]+"~"+MaxAcc[1] + "\n"+ MinAcc[2]+"~"+ MaxAcc[2], 620, 180);
  text("RwAccAvg (G):\n" + RwAccAvg[0] + "\n" + RwAccAvg[1] + "\n" + RwAccAvg[2] , 620, 310);
  text("GyroAvg (°):\n" + GyroAvg[0] + "\n" + GyroAvg[1] + "\n" + GyroAvg[2] , 620, 440);
  text("GyroDeg (°):\n" + GyroDeg[0] + "\n" + GyroDeg[1] + "\n" + GyroDeg[2], 620, 570);
  text("GyroMoveDeg (°):\n" + GyroMoveDeg[0] + "\n" + GyroMoveDeg[1] + "\n" + GyroMoveDeg[2], 620, 700);*/
  text("Quat (°):\n" + QAxis[0] + "\n" + QAxis[1] + "\n" + QAxis[2]+ "\n" + QAxis[3], 20, 700);
  //drawBackground();
  pushMatrix();
  translate(450, 250, 0);
  stroke(#ffffff);

  /*line(0, 0, 0, 100, 0, 0);
  line(0, 0, 0, 0, -100, 0);
  line(0, 0, 0, 0, 0, 100);
  line(0, 0, 0, -RwEst[0]*100, RwEst[1]*100, RwEst[2]*100);*/
  popMatrix();
  drawCube();
  
}
void ClickTabAttitude()
{
  Motor[0].hide();
  MotorLable[0].hide();
  Motor[1].hide();
  MotorLable[1].hide();
  Motor[2].hide();
  MotorLable[2].hide();
  Motor[3].hide();
  MotorLable[3].hide();
  background(0);
  btnTextureSwitch.show();
  myPort.write("@sp"); 
  myPort.write("@mq"); 
  delay(100);
  myPort.clear();  // Clear input buffer up to here
  myPort.write("@ss");  
  println("in attitude tab");
  cursor(ARROW);
  
}

