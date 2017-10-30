import processing.serial.*;
PGraphics tile;

Serial myPort;
int[] val = new int[64];
int[] val2 = new int[64];

void setup() {
  size(1000, 1000);
  
  myPort = new Serial(this, "COM3", 9600);
  myPort.bufferUntil('\n');
  background(0);
  
}

int r =50, m=12, j=0;
float dr = 5;

void draw() {
  background(250);
  noStroke();
  fill(#83BF17);
  for (int k=0; k<m; k++) {
    // delay(10);
    for (int i=k*m/2; i<360+k*m/2; i+=m) {
      float x = width/2+(r+k*m)*cos(radians(i+m));
      float y = height/2+(r+k*m)*sin(radians(i+m));
      float dx = map(k, 0, m, 0, 180);
      dr = 5*cos(radians(dx-j));
      if(val[i%64]<27)
        fill(val[i%64]*4, val[i%64], val[i%64]);
      else if(val[i%64]>=27 && val[i%64]<43) 
        fill(val[i%64], val[i%64]*4, val[i%64]);
      else  
        fill(val[i%64], val[i%64], val[i%64]*4);
      ellipse(x, y, 3*dr, 3*dr);

    }
  }
  if(j<=360)j++;
  else j=0;
   
}


void serialEvent (Serial myPort) {
  try{
    
      //Create buffer for data saving
      byte[] inByte = new byte[200];
      myPort.readBytesUntil(',',inByte);
      byte[] inByte2 = new byte[200];
      
      //Put data into buffer
      myPort.readBytesUntil('\n',inByte2);
      
      // convert to an int and map to the screen height:
      for(int i = 0; i<64; i++){
       val[i] = int(inByte[i]);
        if(val[i] ==0)
         continue;
       print(val[i]);
      
       print("------");
       val2[i] = int(inByte2[i]);
       print(val2[i]);
       print("\n");
      }

  }catch(Exception e){
    println("Err");
  }
}