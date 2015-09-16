class  RC_STATE_T {
  short[] ChannelValue = new short[6];
  float  rssif;
  char arm;
  char mag;
  char headfree;
  char althold;
  char battery;
  char flymode;
  char matching;
  char autolanding;
  char usessv;
  char rcconnected;
};
RC_STATE_T RcState = new RC_STATE_T();
Slider[] Channel = new Slider[6];
Textlabel[] ChannelLable = new Textlabel[6];
//int[] ChannelValue = new int[6];
void UpdateChannels()
{
  Channel[0].setValue(RcState.ChannelValue[0]);
  Channel[1].setValue(RcState.ChannelValue[1]);
  Channel[2].setValue(RcState.ChannelValue[2]);
  Channel[3].setValue(RcState.ChannelValue[3]);
  Channel[4].setValue(RcState.ChannelValue[4]);
  Channel[5].setValue(RcState.ChannelValue[5]);
}
void ChannelBar()
{
  int ChannelBar_W=40, ChannelBar_H=300, ChannelBar_X=150, ChannelBar_Y=150, ChannelText=20, ChannelMin=1000,ChannelMax=2000,ChannelBar_PitchX=100,ChannelBar_PitchY=0;
  
  Channel[3] = cp5.addSlider("Channel4",ChannelMin,ChannelMax,0,ChannelBar_X+ChannelBar_PitchX*0,ChannelBar_Y,ChannelBar_W,ChannelBar_H).setDecimalPrecision(0).setLabel("").hide().moveTo("RC");
  ChannelLable[3] = cp5.addTextlabel("CH4","THR",ChannelBar_X+ChannelBar_PitchX*0,ChannelBar_Y+ChannelBar_PitchY-ChannelText).hide().moveTo("RC");
  Channel[0] = cp5.addSlider("Channel1",ChannelMin,ChannelMax,0,ChannelBar_X+ChannelBar_PitchX*1,ChannelBar_Y,ChannelBar_W,ChannelBar_H).setDecimalPrecision(0).setLabel("").hide().moveTo("RC");
  ChannelLable[0] = cp5.addTextlabel("CH1","ROLL",ChannelBar_X+ChannelBar_PitchX*1,ChannelBar_Y+ChannelBar_PitchY-ChannelText).hide().moveTo("RC");
  Channel[1] = cp5.addSlider("Channel2",ChannelMin,ChannelMax,0,ChannelBar_X+ChannelBar_PitchX*2,ChannelBar_Y,ChannelBar_W,ChannelBar_H).setDecimalPrecision(0).setLabel("").hide().moveTo("RC");
  ChannelLable[1] = cp5.addTextlabel("CH2","PITCH",ChannelBar_X+ChannelBar_PitchX*2,ChannelBar_Y+ChannelBar_PitchY-ChannelText).hide().moveTo("RC");
  Channel[2] = cp5.addSlider("Channel3",ChannelMin,ChannelMax,0,ChannelBar_X+ChannelBar_PitchX*3,ChannelBar_Y,ChannelBar_W,ChannelBar_H).setDecimalPrecision(0).setLabel("").hide().moveTo("RC");
  ChannelLable[2] = cp5.addTextlabel("CH3","YAW",ChannelBar_X+ChannelBar_PitchX*3,ChannelBar_Y+ChannelBar_PitchY-ChannelText).hide().moveTo("RC");
  Channel[4] = cp5.addSlider("Channel5",ChannelMin,ChannelMax,0,ChannelBar_X+ChannelBar_PitchX*4,ChannelBar_Y,ChannelBar_W,ChannelBar_H).setDecimalPrecision(0).setLabel("").hide().moveTo("RC");
  ChannelLable[4] = cp5.addTextlabel("CH5","AUX1",ChannelBar_X+ChannelBar_PitchX*4,ChannelBar_Y+ChannelBar_PitchY-ChannelText).hide().moveTo("RC");
  Channel[5] = cp5.addSlider("Channel6",ChannelMin,ChannelMax,0,ChannelBar_X+ChannelBar_PitchX*5,ChannelBar_Y,ChannelBar_W,ChannelBar_H).setDecimalPrecision(0).setLabel("").hide().moveTo("RC");
  ChannelLable[5] = cp5.addTextlabel("CH6","AUX2",ChannelBar_X+ChannelBar_PitchX*5,ChannelBar_Y+ChannelBar_PitchY-ChannelText).hide().moveTo("RC");
  
}
void SliderRC()
{
  ChannelBar();
}
void readChannels()
{
  int i;
  while (myPort.available() >= 26)
  { 
    RcState.ChannelValue[0] = readInt16(myPort);
    RcState.ChannelValue[1] = readInt16(myPort);
    RcState.ChannelValue[2] = readInt16(myPort);
    RcState.ChannelValue[3] = readInt16(myPort);
    RcState.ChannelValue[4] = readInt16(myPort);
    RcState.ChannelValue[5] = readInt16(myPort);
    RcState.rssif = readFloat(myPort);
    RcState.arm = readChar(myPort);
    RcState.mag = readChar(myPort);
    RcState.headfree = readChar(myPort);
    RcState.althold = readChar(myPort);
    RcState.battery = readChar(myPort);
    RcState.flymode = readChar(myPort);
    RcState.matching = readChar(myPort);
    RcState.autolanding = readChar(myPort);
    RcState.usessv = readChar(myPort);
    RcState.rcconnected = readChar(myPort);
   
  }
  println(RcState.ChannelValue[0]+" "+RcState.ChannelValue[1]+" "+RcState.ChannelValue[2]+" "+RcState.ChannelValue[3]+" "+RcState.ChannelValue[4]+" "+RcState.ChannelValue[5] +"  "+  RcState.rssif);
}
void DrawTabRC() 
{
  String [] FunctionMode = {"Attitude", "Mag", "Headfree"};
  String [] Switch = {"OFF","ON"};
  String Mode;
  String arm,mag,headfree,althold,battery,
  flymode,matching,autolanding,usessv,rcconnected,rssi;

  //println("->DrawTabCalibration");
  background(0);
  noFill();
  readChannels();
  UpdateChannels();
  fill(#ffffff);
  textFont(font, 20);
  if(RcState.headfree==1)
    Mode = FunctionMode[2];
  else if(RcState.mag==1)
    Mode = FunctionMode[1];
  else
    Mode = FunctionMode[0];
    
  arm = Switch[RcState.arm];  
  althold = Switch[RcState.althold];
  //battery = Switch[RcState.battery];  
  flymode = Switch[RcState.flymode];
  matching = Switch[RcState.matching];  
  autolanding = Switch[RcState.autolanding];
  usessv = Switch[RcState.usessv];  
  rcconnected = Switch[RcState.rcconnected];
  //rssi = string(RcState.rssif);

  text("AltHold(AUX1):" + althold+"\n" , 200, 600);
  text("Use 2.4G:" +usessv+"\n" , 200, 625);
  text("RC Connect: " +rcconnected+"\n" , 200, 650);
  text("Armed: " +arm+"\n" , 200, 675);
  text("Fly Mode: " +flymode+"\n" , 200, 700);
  text("RC Matching: " +matching+"\n" , 200, 725);
  text("Auto Landing: " +autolanding+"\n" , 200, 750);
  
  
  text("Mode   (AUX2): " + Mode+"\n" , 400, 600);
  text("Battery: " +(int)RcState.battery +"\n" , 400, 625);
  text("RSSI: " + (float)RcState.rssif+"\n" , 400, 650);
 

}
void ClickTabRC()
{
  println("->ClickTabRC");
  background(0);
  Channel[0].show();
  ChannelLable[0].show();
  Channel[1].show();
  ChannelLable[1].show();
  Channel[2].show();
  ChannelLable[2].show();
  Channel[3].show();
  ChannelLable[3].show();
  Channel[4].show();
  ChannelLable[4].show();
  Channel[5].show();
  ChannelLable[5].show();
  myPort.write("@sp");
  myPort.write("@msr"); 
  delay(100);
  myPort.clear();
  myPort.write("@ss"); 
  
}
