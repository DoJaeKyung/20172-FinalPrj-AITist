import processing.serial.*;

Serial myPort;        // The serial port
int[] val = new int[128];
int colorByAmplitude;

int howMany = 400;
float[] x = new float[howMany];
float[] y = new float[howMany];
float[] speed = new float[howMany];
 
void setup() {
  size(200, 800);
  background(255,248,21);
  myPort = new Serial(this, "COM3", 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');  

  noStroke();
  smooth();
 
  int i = 0;
  while (i<howMany) { 
    x[i] = random(0, width);
    y[i] = random(0, height);
    speed[i] = random(1,5);
    i +=1;
  }
}
 
void draw() {

  fill(188,27,247,3);
  rect(0,0,width, height);
 
  int i = 0;
  int count=0;
  while (i < howMany) {
    if(count % 5 ==0)
      fill(colorByAmplitude,80*speed[i]);
    else
      fill(10,182,203,80*speed[i]);
    ellipse(x[i], y[i],speed[i],speed[i]);
    y[i] += speed[i]/4;
    if (y[i] > height) {
      y[i] = 0;
    }
    count++;
    i +=1;
  }
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
            colorByAmplitude = setColor((i*390*2/45)+380);
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