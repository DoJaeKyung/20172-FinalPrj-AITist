import processing.serial.*;
PGraphics tile;

Serial myPort;
int[] val = new int[64];
int[] val2 = new int[64];

void setup() {
  size(700, 700);
  
  myPort = new Serial(this, "/dev/cu.usbmodem1411", 9600);
  myPort.bufferUntil('\n');
  background(255);
  tile = createGraphics(50, 50);
  
}

void draw() {
  runTile();
  for (int y = 0; y < height; y += tile.height) {
    for (int x = 0; x < width; x += tile.width) {
      image(tile, x, y);
      }
   }
}

void runTile() {
  
  //float x = random(20, tile.width-20);
  //float y = random(20, tile.height-20);
  float x = random(20, tile.width-20);
  float y = random(20, tile.height-20);
  
  tile.beginDraw();
  tile.noStroke();
  
  tile.fill(0, 20);
  tile.rect(0, 0, tile.width, tile.height);
  for(int i = 0; i < 64; ++i){
    tile.fill(val2[i], val2[i], val2[i]);
  }
  for(int i = 0; i < 64; ++i){
    fill(0,0,0);
    tile.ellipse(val[i], val[i], 10, 10);
  }
  tile.endDraw();
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