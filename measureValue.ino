/* Arduino Code */

#include "arduinoFFT.h"

arduinoFFT FFT = arduinoFFT(); /* Create FFT object */
/*
These values can be changed in order to evaluate the functions
*/
const uint16_t samples = 128; //This value MUST ALWAYS be a power of 2
double signalFrequency = 1000;
double samplingFrequency = 5000;
uint8_t amplitude = 100;
/*
These are the input and output vectors
Input vectors receive computed results from FFT
*/
double vRealForSoundValue[samples];
double vReal[samples];
double vImag[samples];

#define SCL_INDEX 0x00
#define SCL_TIME 0x01
#define SCL_FREQUENCY 0x02

#define Theta 6.2831 //2*Pi

void setup()
{
  Serial.begin(9600);
}

void loop()
{
  for (uint8_t i = 0; i < samples; i++)
  {
    vReal[i] = analogRead(A0);
    vRealForSoundValue[i] = vReal[i];
    
    delayMicroseconds(100);
    vImag[i] = 0;
  }
  FFT.Windowing(vReal, samples, FFT_WIN_TYP_HAMMING, FFT_FORWARD);  /* Weigh data */
  FFT.Compute(vReal, vImag, samples, FFT_FORWARD); /* Compute FFT */
  FFT.ComplexToMagnitude(vReal, vImag, samples); /* Compute magnitudes */
  PrintVector(vReal, vRealForSoundValue, (samples >> 1), SCL_FREQUENCY);
}

void PrintVector(double *vData, double *vDataForSoundValue, uint8_t bufferSize, uint8_t scaleType)
{
  for (uint16_t i = 2; i < bufferSize; i++)
  {
    uint8_t val_temp = vData[i];
    //uint8_t val_temp = map(vData[i],0,1000,0,1000);
    //uint8_t val_temp = map(vData[i],0,1000,0,255);
    Serial.write(val_temp);
  }
  Serial.write(',');
  
  for (uint16_t i = 2; i < bufferSize; i++)
  {
    uint8_t val_temp = vDataForSoundValue[i];
    //uint8_t val_temp = map(vDataForSoundValue[i],0,1023,0,1000);
    //uint8_t val_temp = map(vDataForSoundValue[i],0,1023,0,255);
    Serial.write(val_temp);
  }
  Serial.write('\n');
}
