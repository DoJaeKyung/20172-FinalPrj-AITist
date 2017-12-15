import processing.serial.*;

Serial myPort;        // The serial port

int[] val = new int[128];
int colorByAmplitude;

float t;
float theta;
int maxFrameCount = 75;

int a = 101; // offset number
int space = 100; // size of cube for for loops

color c1;
color c2;

void setup(){
  size(540,540, P3D);
  myPort = new Serial(this, "COM3", 9600);
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');  
  noStroke();
  smooth();
  
}

void draw(){
  background(5);
  translate(width/2,height/2);
  t = (float)frameCount/maxFrameCount;
  theta = TWO_PI*t;

  //기본적인 빛 설정
  directionalLight(245, 245, 245, 300, -200, -200);  
  ambientLight(240, 240, 240); 
  
  //큐브의 회전 각도 설정
  rotateY(radians(145));
  rotateX(radians(45));
  
//3개의 포문을 통해 x,y,z 측면 설계
  for (int x = -space; x <= space; x += 20) {
  for (int y = -space; y <= space; y += 20) {
  for (int z = -space; z <= space; z += 200) {

    //큐브속의 작은 큐브 사이즈 설정
    float offSet = ((x*y*z))/a;
    float sz = map(sin(-theta+offSet), -1, 1, -0, 20);
/*
    color c1 = color(240,40,100);
    color c2 = color(40,40,90);*/
    
    //주파수에 따라 컬러 입힘
    color c1 = color(colorByAmplitude);
    color c2 = color(40,40,90);

   
  if ((x*y*z)%30 == 0){
    fill(c1);
    stroke(c2);
  } else {
    fill(c2);
    stroke(c1);
  }
    
    //작은 사이즈의 큐브 생성
    shp(x,y,z,sz);
    shp(y,z,x,sz);
    shp(z,x,y,sz);

    }}}


  } //큐브 생성 끝

  void shp(float x, float y,  float z, float d){
    
         pushMatrix();
         translate(x,y,z);
         box(d);
         popMatrix();
         
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
    
    //randomSeed(111);
    R = pow((float)((-(float)(waveLength - 440)/(440 - 380)) * attenuation), (float)gamma);
    G = r;
    B = pow((float)(1.0 * attenuation), (float)gamma);
  } else if (waveLength < 490 && waveLength >= 440){
    //randomSeed(111);
    
    R = r;
    G = pow((float)(waveLength-440)/(490-440), (float)gamma); 
    B = 1; 
  } else if (waveLength < 510 && waveLength >= 490){
    //randomSeed(111);
    
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

String toHex(double x) {
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
