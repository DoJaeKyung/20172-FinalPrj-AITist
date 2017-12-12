import processing.serial.*;

Serial myPort;        // The serial port

int[] val = new int[128];
int colorByAmplitude;

PImage img;
PImage img2;

void setup() {
  size(700, 700);
  
  myPort = new Serial(this, "/dev/cu.usbmodem1421", 9600);
  
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');
  img = loadImage("murakami3.jpg");
  //img2 = loadImage("murakami3.jpg");
  imageMode(CENTER);
  noStroke();
  background(255);
}

void draw() { 
  int i = 0;
  while (i <= 25) {
    drawPoint();
    i = i +1;
  }
}

void drawPoint() {

  
  int x = int(random(img.width));
  int y = int(random(img.height));
  color pix = img.get(x, y);
  //color pix = colorByAmplitude;
  
  float value = brightness (pix);
  int i = round( map (value, 0, 255, 0, 700*700-1) );
  
  color c2 = colorByAmplitude;
 // color c2 = img2.pixels[i];

  fill(c2, 128);
  rect(x, y, random(0,15), random(0,15));
}

void serialEvent (Serial myPort) {
  try{
      byte[] inByte = new byte[200];
      myPort.readBytesUntil('\n',inByte);
      
        // convert to an int and map to the screen height:
        for(int i = 0; i<128; i++){
         val[i] = int(inByte[i]);
         if(val[i] > 155 && val[i+1] > 155 && val[i+1] > 155 && i < 126 && i !=0 )
         {
           //print(i*390);
           //print('\t');
           //print(val[i]);
           //print('\t');
           //print("Changed : ");
           //print((i*390*2/45)+380);
           //// amplitude to color
           //print('\n');
            colorByAmplitude = setColor((i*390*2/45)+380);
            
           //print(hex(32,2));
           //print('\n');
         }
        }
        redraw();

  }catch(Exception e){
    println("Err");
  }
}

int setColor(int inputValue) // Dan Bruton's Wavelength to RGB mapping method
{
  int waveLength, result;
  double R = 0, G = 0, B = 0, c;
  String hexNum;
  
  waveLength = inputValue; // getValue from serialEvent
  
  if (waveLength < 380 || waveLength > 780){ 
    //get.value = "Wrong range! (380~780 nm) must be wavelength range";  
  } else if (waveLength < 440){ 
    R = (440-waveLength)/(440-380); 
    G = 0; 
    B = 1; 
  } else if (waveLength < 490){ 
    R = 0; 
    G = (waveLength-440)/(490-440); 
    B = 1; 
  } else if (waveLength < 510){ 
    R = 0; 
    G = 1; 
    B = (510-waveLength)/(510-490); 
  } else if (waveLength < 580){ 
    R = (waveLength-510)/(580-510); 
    G = 1; 
    B = 0; 
  } else if (waveLength < 645){ 
    R = 1; 
    G = (645-waveLength)/(645-580); 
    B = 0; 
  } else { 
    /* (waveLength <=780) */ 
    R = 1; 
    G = 0; 
    B = 0; 
  }

  if (waveLength > 700){ 
    c = 0.3 + (0.7*((780-waveLength)/80)); 
    R *= c; 
    G *= c; 
    B *= c;
  }
  
  if (waveLength < 420){ 
    c = 0.3 + (0.7*((waveLength-380)/40)); 
    R *= c; 
    G *= c; 
    B *= c;
  }
  
  hexNum = toHex(R) + toHex(G) + toHex(B);
  print(hexNum);
  print('\n');
  
  result = unhex(hexNum);
  return result;
}

String toHex(double x) {
  int value;
  String result;
  
  x = Math.floor(x*255);
  value = (int)x;
  result = hex(value, 2);
  
  return result;
}