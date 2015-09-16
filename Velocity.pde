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
cGraph g_graph =  new cGraph(50,50, 800, 500);
float[] Velocity = new float[6];
cDataArray[] myInputArray = {new cDataArray(200), new cDataArray(200), new cDataArray(200),
new cDataArray(200), new cDataArray(200), new cDataArray(200)};

class cGraph {
  float m_gWidth, m_gHeight, m_gLeft, m_gBottom, m_gRight, m_gTop;
  cGraph(float x, float y, float w, float h) {
    m_gWidth     = w; m_gHeight    = h;
    m_gLeft      = x; m_gBottom    = y;
    m_gRight     = x + w;
    m_gTop       = y + h;
  }
  void drawGraphBox() {
    stroke(0, 0, 0);
    rect(m_gLeft, m_gBottom, m_gWidth, m_gHeight);
  }
  void drawLine(cDataArray data, float minRange, float maxRange) {
    float graphMultX = m_gWidth/data.getMaxSize();
    float graphMultY = m_gHeight/(maxRange-minRange);
    for(int i=0; i<data.getCurSize()-1; ++i) {
      float x0 = i*graphMultX+m_gLeft;
      float y0 = m_gTop-(((data.getVal(i)-(maxRange+minRange)/2)*1+(maxRange-minRange)/2)*graphMultY);
      float x1 = (i+1)*graphMultX+m_gLeft;
      float y1 = m_gTop-(((data.getVal(i+1)-(maxRange+minRange)/2 )*1+(maxRange-minRange)/2)*graphMultY);
      line(x0, y0, x1, y1);
    }
  }
}
class cDataArray {
  float[] m_data;
  float mean,varience;
  int m_maxSize, m_startIndex = 0, m_endIndex = 0, m_curSize;
  
  cDataArray(int maxSize){
    m_maxSize = maxSize;
    m_data = new float[maxSize];
  }
  void addVal(float val) {
    m_data[m_endIndex] = val;
    m_endIndex = (m_endIndex+1)%m_maxSize;
    if (m_curSize == m_maxSize) {
      m_startIndex = (m_startIndex+1)%m_maxSize;
    } else {
      m_curSize++;
    }
  }
  float getVal(int index) {return m_data[(m_startIndex+index)%m_maxSize];}
  int getCurSize(){return m_curSize;}
  int getMaxSize() {return m_maxSize;}
  float getMaxVal() {
    float res = 0.0;
    for(int i=0; i<m_curSize-1; i++) if ((m_data[i] > res) || (i==0)) res = m_data[i];
    return res;
  }
  float getMinVal() {
    float res = 0.0;
    for(int i=0; i<m_curSize-1; i++) if ((m_data[i] < res) || (i==0)) res = m_data[i];
    return res;
  }
  float getMean() {
    float sum = 0.0;
    for(int i=0; i<m_curSize-1; i++)
    {
      sum+=m_data[i];
    }
    mean = sum/m_curSize;
    return mean;
  }
  float getVarience() {
    float sum = 0.0,diff;
    for(int i=0; i<m_curSize-1; i++)
    {
      diff = (mean-m_data[i]);
      sum+=diff*diff;
    }
    sum=sum/m_curSize;
    varience = sqrt(sum);
    return varience;
  }
  float getRange() {return getMaxVal() - getMinVal();}
}
void Baro() 
{
  String token; 
  myPort.write("@sp");
  delay(100);
  myPort.clear();
  myPort.write("@me");
  delay(100);
  myPort.write("@ss");
  VelocityTabLength = 4;
  StartCounter = 0;
}
void Velocity() 
{
  String token; 
  myPort.write("@sp");
  delay(100);
  myPort.clear();
  myPort.write("@mv");
  delay(100);
  myPort.write("@ss");
  VelocityTabLength = 6;
}
void ButtonVelocity()
{
  int offY=100,offX=100;
  btnBaro=cp5.addButton("Baro")
     .setValue(0)
     .setPosition(offX,offY)
     .setSize(120,80)   
     .setColorBackground(#6060a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("Velocity")
     .hide();
     
   btnVelocity=cp5.addButton("Velocity")
     .setValue(0)
     .setPosition(offX+200,offY)
     .setSize(120,80)   
     .setColorBackground(#6060a0)
     .setColorForeground(#8080d0)
     .setColorActive(#a0a0f0)
     .setColorCaptionLabel(#ffff00)
     .moveTo("Velocity")
     .hide();
}

void drawMotionGraph()
{
  // ---------------------------------------------------------------------------------------------
  // GRAPH
  // ---------------------------------------------------------------------------------------------
  strokeWeight(1);
  fill(#a0a8a0);
  g_graph.drawGraphBox();
  
  strokeWeight(1.5);
  stroke(#000000); g_graph.drawLine(myInputArray[0], -180, +180);
  stroke(#00ff00); g_graph.drawLine(myInputArray[1], -180, +180);
  stroke(#0000ff); g_graph.drawLine(myInputArray[2], -180, +180);
 
}
void addMotionArray(int axis, float data)
{
  myInputArray[axis].addVal(data);
}
float GetMotionArrayMean(int axis)
{
  return myInputArray[axis].getMean();
}
float GetMotionArrayVarience(int axis)
{
  return myInputArray[axis].getVarience();
}
void readVelocity()
{
  int i;
  while (myPort.available() >= 4*VelocityTabLength)
  { 
    for(i=0;i<VelocityTabLength;i++)
      Velocity[i] = readFloat(myPort);
    }
}
void DrawTabVelocity()
{
  background(#000000);
    fill(#ffffff);
    readVelocity();
    if(VelocityTabLength==6) {
      addMotionArray(0, Velocity[0]*100);
      addMotionArray(1, Velocity[1]*100);
      addMotionArray(2, Velocity[2]*100);
      println(Velocity[0]+"   "+Velocity[1]+"     "+Velocity[2]);
    }
    else {
      if(StartCounter++<20)
        StartAlt = StartAlt*0.5 + 0.5*Velocity[3];
 
      addMotionArray(0, (Velocity[3]-StartAlt)*50);
      addMotionArray(1, 50);
      addMotionArray(2, -50);
      addMotionArray(3, Velocity[3]);
      println(Velocity[3]);
      text("MEAN:" + GetMotionArrayMean(3) + "\nVarience:" + GetMotionArrayVarience(3), 320, 700);
    }
    drawMotionGraph();
}
void ClickTabVelocity()
{
  btnBaro.show();
  btnVelocity.show();
  if(VelocityTabLength==6)
    Velocity();
  else
    Baro();
}
