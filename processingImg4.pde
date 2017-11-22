/* Processing code */
import processing.serial.*;

Serial myPort;        // The serial port

int[] val = new int[128];

void setup () {
  // set the window size:
  size(1024, 1024);

  myPort = new Serial(this, "/dev/cu.usbmodem1411", 9600);
  
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');

  // set inital background:
  background(255);
  rect(0, 0, 1024, 1024);
  stroke(255,0,0);
  noLoop();
  delay(2000);
}

void draw () {
    background(255);

    for (int i =0; i<128; i++){
      line(i*8 +1,height,i*8 +1,height-val[i]*4);
    }   
}

void serialEvent (Serial myPort) {
  try{
      byte[] inByte = new byte[200];
      int max = 0;
      myPort.readBytesUntil('\n',inByte);
      
        // convert to an int and map to the screen height:
        for(int i = 0; i<128; i++){
         val[i] = int(inByte[i]);
         if(val[i] > 155 && val[i+1] > 155 && val[i+1] > 155 && i < 126 && i !=0 )
         {
           print(i*390);
           print('\t');
           print(val[i]);
           print('\t');
           print("Changed : ");
           print((i*390*2/45)+380);
           print('\n');
         }
        }
        redraw();

  }catch(Exception e){
    println("Err");
  }
}