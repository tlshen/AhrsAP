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
Button loadButton,saveButton,btnQConnect;
ListBox ListCom;
Textlabel txtWhichcom;
int ComListMax, init_com;
String portnameFile="SerialPort.txt";
String portName = "COM0";
int GUI_BaudRate = 115200;
int SerialPort = 0;
Serial g_serial;
PrintWriter output;
BufferedReader reader;
Serial myPort;
boolean EnterFirstTab = true;

void SaveSerialPort() {
    output = createWriter(portnameFile);
    output.print( portName + ';' + GUI_BaudRate);
    output.flush();
    output.close();
}
void ReadSerialPort() {
  reader = createReader(portnameFile);  
  String line; 

    try {
      line = reader.readLine();
    } catch (IOException e) {
      e.printStackTrace();
      line = null; 
    }
       
    if (line == null) {
      println("file empty");
      btnQConnect.hide();
     return;
    } else {
      String[] pieces = split(line, ';');
      int Port = int(pieces[0]);
      GUI_BaudRate= int(pieces[1]);
      print("BR:"+GUI_BaudRate+"Port:"+pieces[0]);
      if (ComListMax==1){}
      String pPort=pieces[0];
      for( i=0;i<ComListMax;i++) {
        String[] pn =  match(Serial.list()[i],  pieces[0]);    
        if ( pn !=null){ SerialPort=i;}
      }
    }
}
void ClearSerialOperationColor()
{
  for(i=0;i<ComListMax;i++) {
    ListCom.getItem(i).setColorBackground(white_);
  }
}

void InitSerial(float portValue) {
  if ((portValue < ComListMax) && g_serial==null){
    portName = Serial.list()[int(portValue)];
    ClearSerialOperationColor();
    println("initSerial");
    try {
      g_serial = new Serial(this, portName, GUI_BaudRate);
      
    } catch (Exception e) {
      e.printStackTrace();
      g_serial = null; 
      println("g_serial = null");
    }
    if(g_serial!=null) {
      ListCom.getItem(int(portValue)).setColorBackground(green_);
      txtWhichcom.setValue("Port = " + portName);
      SaveSerialPort();
      init_com=1;
      g_serial.buffer(256);
      btnQConnect.hide();
      btnReportAHRS0.show();
      btnReportAHRS1.show();
    }
  } else {
    txtWhichcom.setValue("Comm Closed");
    init_com=0;
    g_serial.stop();
    g_serial = null;
    ClearSerialOperationColor();
    btnQConnect.show();
    cp5.getTab("ATTITUDE").hide();
    cp5.getTab("PID").hide();
    cp5.getTab("Velocity").hide();
    cp5.getTab("Calibration").hide();
    cp5.getTab("RC").hide();
    btnReportAHRS0.hide();
    btnReportAHRS1.hide();
    synched = false;
    EnterFirstTab = true;
  }
}
public void AHRS0(int theValue) {
  if(synched)
    myPort.write("@sa0");
}
public void AHRS1(int theValue) {
  if(synched)
    myPort.write("@sa1");
}
public void bQCONN(){
  ReadSerialPort();
  InitSerial(SerialPort);
  g_serial.clear();
  myPort = g_serial;
}
void DrawTabCOM()
{
  //background(#000000);
  fill(#ffffff);
  if(g_serial!=null) {
    if(!Sync2NvtFly())
      return;
    else {
      cp5.getTab("ATTITUDE").show();
      cp5.getTab("PID").show();
      cp5.getTab("Velocity").show();
      cp5.getTab("Calibration").show();
      cp5.getTab("RC").show();
      cp5.getTab("GPS").show();
      textFont(pfont,16);
      text("Firmware Version:" + Version[1], 242, 300);
      text("Board    Version:" + Board[1], 242, 315);
      if(EnterFirstTab) {
        cp5.getTab("Calibration").setMousePressed(true);
        EnterFirstTab = false;
      }
    }
  }
  cursor(ARROW);
}


