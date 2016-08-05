#include <Wire.h>

/*FIFO_READ_SIZE should be a even divisor of 512*/
#define FIFO_READ_SIZE  32    
#define DEBUG           0
#define FIFO_SENSORS    8+16+32+64

uint8_t mpuAddr = 0;

void configSensors(uint8_t addr)
{
  Wire.beginTransmission(addr);
  Wire.write(28);                   /*Acc config*/
  Wire.write(0);                    /*scale +- 2g*/
  Wire.endTransmission(true);

  Wire.beginTransmission(addr);
  Wire.write(29);                   /*Acc config 2*/
  Wire.write(4);                    /*Freq 1kHz*/
  Wire.endTransmission(true);

  Wire.beginTransmission(addr);
  Wire.write(25);                   /*Sample Rate*/
  Wire.write(0);                    /*max*/
  Wire.endTransmission(true);

  Wire.beginTransmission(addr);
  Wire.write(27);                   /*Gy Config*/
  Wire.write(0);                    /*scale +250dps*/
  Wire.endTransmission(true);
  

}

int8_t initMPU(uint8_t addr)
{
  
  Wire.beginTransmission(addr);
  Wire.write(26);               /*Set FIFO_MODE*/
  Wire.write(64+1);             /*FIFO_MODE = 1 -> no overflow*/
  Wire.endTransmission(true);
  Wire.beginTransmission(addr);
  Wire.write(35);               /*Set FIFO_EN*/
  Wire.write(FIFO_SENSORS);       /*Enable ACC, GyX, GyY, GyZ*/
  Wire.endTransmission(true);
  Wire.beginTransmission(addr);
  Wire.write(106);              /*USER_CTRL*/
  Wire.write(64+4+1);           /*Enable FIFO, Reset Signals, reset Counter*/
  Wire.endTransmission(true);
  Wire.beginTransmission(addr);
  Wire.write(107);              /*Power Management 1*/
  Wire.write(0);                /*Internal 20MHz oscillator, no low power*/
  Wire.endTransmission(true);
}

int8_t testMPUAddr(uint8_t addr)
{
  Wire.beginTransmission(addr);
  Wire.write(0x75);             /*"Who am I" register*/
  Wire.endTransmission(false);
  Wire.requestFrom(addr,1,true);
  return Wire.read();
}

void setup() {
  Serial.begin(115200);
  Wire.begin();
#if DEBUG
  Serial.println("Starting:");
#endif
  uint8_t addr;
  for(addr = 10; addr < 0xFF; addr++)
  {
    if(testMPUAddr(addr) != -1)
    {
      break;
    }
  }
#if DEBUG
  Serial.print("Found MPU on addr: ");
  Serial.println(addr);
#endif
  initMPU(addr);
  configSensors(addr);
  mpuAddr = addr;
}

void getData(uint16_t size)
{
  int16_t data;
  
  int16_t i,j,k;
#if DEBUG
  unsigned long time = millis();
#endif
  for(i = 0; i < 512; i+=FIFO_READ_SIZE)
  {
    Wire.beginTransmission(mpuAddr);
    Wire.write(0x74);
    Wire.endTransmission(false);       
    Wire.requestFrom(mpuAddr,FIFO_READ_SIZE,true);
    for(j = 0; j < FIFO_READ_SIZE/2; j++)
    {
        data = Wire.read()<<8;
        data = data|Wire.read();  
        Serial.println(data);
    }
#if DEBUG
    Serial.println("--");
#endif
    Wire.endTransmission(true);    
  }
  Serial.println("-100000");
#if DEBUG
  Serial.println(millis()-time);
#endif
}

void loop() {
  // put your main code here, to run repeatedly:
  uint16_t cntr;
  Wire.beginTransmission(mpuAddr);
  Wire.write(0x72); /*Counter register*/
  Wire.endTransmission(false);
  Wire.requestFrom(mpuAddr,2,true);
  cntr = Wire.read()<<8|Wire.read();
  Wire.endTransmission(true);    

#if DEBUG
  Serial.println("----------");
  Serial.println(cntr);
#endif
  if(cntr >= 512)
  {
    Wire.beginTransmission(mpuAddr);
    Wire.write(0x23);
    Wire.write(0); /*Disable FIFO recordings*/
    Wire.endTransmission(true);    
    getData(1024);
    Wire.beginTransmission(mpuAddr);
    Wire.write(0x6A);
    Wire.write(64+4); /*Reset FIFO*/
    Wire.endTransmission(true);
    Wire.beginTransmission(mpuAddr);
    Wire.write(0x23); /*Enable FIFO recording of ACC*/
    Wire.write(FIFO_SENSORS);
    Wire.endTransmission(true);  
  }
  //delay(1000);
   
}
