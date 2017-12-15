import processing.serial.*;

Serial myPort;        // The serial port

int[] val = new int[128];
int colorByAmplitude;
int type;

void setup() {
  size(600,600);
  myPort = new Serial(this, "COM3", 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');  
  type=0;
  noStroke();
  smooth();
  
}

void draw() {
  blendMode(BLEND);
  
  if(type == 0) {
    background(255);
    blendMode(EXCLUSION);
  } else {
    background(0);
    blendMode(SCREEN);
  }
  noFill();
  strokeWeight(20);
  for(int i = 0; i < 3; i++) {
    stroke(colorByAmplitude);
    beginShape();
    for(int w = -20; w < width + 20; w += 5) {
      int h = height / 2;
      h += 200 * sin(w * 0.03 + frameCount * 0.07 + i * TWO_PI / 3) * pow(abs(sin(w * 0.001 + frameCount * 0.02)), 5);
      curveVertex(w, h);
    }    
    endShape();
  }
  
}

void mousePressed() {
  if(type == 0) {
    type = 1;
  } else {
    type = 0;
  }
}


////////////////


void serialEvent (Serial myPort) {
  try{
      byte[] inByte = new byte[400];
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
           // amplitude to color
           print('\n');
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
  double R = 0, G = 0, B = 0, gamma = 0.8, r, attenuation;
  String hexNum;
  
  waveLength = inputValue; // getValue from serialEvent

  r = random(0, 111);
  if (waveLength < 380 || waveLength > 780){
    
  } else if (waveLength < 440 && waveLength >= 380){ 
    attenuation = 0.3 + (0.7*(waveLength-380)/(440-380));
    
    R = pow((float)((-(float)(waveLength - 440)/(440 - 380)) * attenuation), (float)gamma);
    G = r;
    B = pow((float)(1.0 * attenuation), (float)gamma);
  } else if (waveLength < 490 && waveLength >= 440){
    
    R = r;
    G = pow((float)(waveLength-440)/(490-440), (float)gamma); 
    B = 1; 
  } else if (waveLength < 510 && waveLength >= 490){
 
    R = r; 
    G = 1; 
    B = pow((float)(-(float)(waveLength - 510) / (510 - 490)), (float)gamma);
  } else if (waveLength <= 580 && waveLength > 510){
    R = pow((float)((float)(waveLength - 510)/(580 - 510)), (float)gamma); 
    G = 1; 
    B = r;
  } else if (waveLength <= 645 && waveLength > 580){    
    R = 1; 
    G = pow((float)(-(float)(waveLength - 645)/(645 - 580)), (float)gamma);
    B = r;
  } else if (waveLength > 645 && waveLength <= 750){
    attenuation = 0.3 + (0.7*(float)(750 - waveLength)/(750 - 645));
    
    R = pow((float)(1.0 * attenuation), (float)gamma);
    G = r;
    B = r;
  } else { 
    R = 0; 
    G = 0; 
    B = 0; 
  }
  
  hexNum = "#" + toHex(R) + toHex(G) + toHex(B);
  hexNum = "FF" + hexNum.substring(1);
  print(hexNum);
  print('\t');
  result = unhex(hexNum);
  print(result);
  print('\n');
  
  return result;
}

String toHex(double x) { //RGB 값을 String형태의 16진수로 변환
  int value;
  String result;
  
  // random interval : 0 - 144
  if(x < 1){
    x = Math.floor(x*255);
  }

  value = (int)x;

  result = hex(value, 2);
  
  return result;
}
