#include <Wire.h>

#define MPU_ADDR        0x68
#define FIFO_READ_SIZE  6
#define FIFO_READ_NUM   5
#define DEBUG           0

void configAcc()
{
  Wire.beginTransmission(MPU_ADDR);
  Wire.write(28); /*Acc config*/
  Wire.write(0);  /*scale +- 2g*/
  Wire.endTransmission(true);

  Wire.beginTransmission(MPU_ADDR);
  Wire.write(29); /*Acc config 2*/
  Wire.write(4);  /*Freq 1kHz*/
  Wire.endTransmission(true);

  Wire.beginTransmission(MPU_ADDR);
  Wire.write(25); /*Sample Rate*/
  Wire.write(0);  /*1/4*/
  Wire.endTransmission(true);

  Wire.beginTransmission(MPU_ADDR);
  Wire.write(27); /*Sample Rate*/
  Wire.write(0);  /*1/4*/
  Wire.endTransmission(true);
  

}

int8_t initMPU(uint8_t addr)
{
  
  Wire.beginTransmission(addr);
  Wire.write(0x1A); /*Set FIFO_MODE*/
  Wire.write(64+1);    /*FIFO_MODE = 1 -> no overflow*/
  Wire.endTransmission(true);
  Wire.beginTransmission(addr);
  Wire.write(0x23); /*Set FIFO_EN*/
  Wire.write(8);    /*Enable only ACC*/
  Wire.endTransmission(true);
  Wire.beginTransmission(addr);
  Wire.write(0x6A);    /*USER_CTRL*/
  Wire.write(64+4+1);  /*Enable FIFO, Reset Signals, reset Counter*/
  Wire.endTransmission(true);
  Wire.beginTransmission(addr);
  Wire.write(0x6B);
  Wire.write(0);
  Wire.endTransmission(true);
  
  Wire.beginTransmission(addr);
  Wire.write(0x75); /*Counter register*/
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
    if(initMPU(addr) != -1)
    {
      break;
    }
  }
#if DEBUG
  Serial.print("Found MPU on addr: ");
  Serial.println(addr);
#endif
  configAcc();
}

void getData(uint16_t size)
{
  int16_t data;
  Wire.beginTransmission(MPU_ADDR);
  Wire.write(0x74);
  Wire.endTransmission(false);
  
  int16_t i,j,k;
#if DEBUG
  unsigned long time = millis();
#endif
  Serial.println("-100000");
  for(i = FIFO_READ_SIZE*FIFO_READ_NUM; i < 512; i+=FIFO_READ_SIZE*FIFO_READ_NUM)
  {
    Wire.beginTransmission(MPU_ADDR);
    Wire.write(0x74);
    Wire.endTransmission(false);       
    Wire.requestFrom(MPU_ADDR,FIFO_READ_SIZE*FIFO_READ_NUM,true);
    for(j = 0; j < FIFO_READ_NUM; j++)
    {
      for(k = 0; k < FIFO_READ_SIZE/2; k++)
      {
        data = Wire.read()<<8;
        data = data|Wire.read();  
        Serial.println(data);
      }
    }
#if DEBUG
    Serial.println("--");
#endif
    Wire.endTransmission(true);    
  }
  
#if DEBUG
  Serial.println(millis()-time);
#endif
}

void loop() {
  // put your main code here, to run repeatedly:
  uint16_t cntr;
  Wire.beginTransmission(MPU_ADDR);
  Wire.write(0x72); /*Counter register*/
  Wire.endTransmission(false);
  Wire.requestFrom(MPU_ADDR,2,true);
  cntr = Wire.read()<<8|Wire.read();
  Wire.endTransmission(true);    

#if DEBUG
  Serial.println("----------");
  Serial.println(cntr);
#endif
  if(cntr >= 512)
  {

    Wire.beginTransmission(MPU_ADDR);
    Wire.write(0x23);
    Wire.write(0); /*Disable FIFO recordings*/
    Wire.endTransmission(true);    
    getData(1024);
    Wire.beginTransmission(MPU_ADDR);
    Wire.write(0x6A);
    Wire.write(64+4); /*Reset FIFO*/
    Wire.endTransmission(true);    
    Wire.beginTransmission(MPU_ADDR);
    Wire.write(0x23); /*Enable FIFO recording of ACC*/
    Wire.write(8);
    Wire.endTransmission(true);  
  }
  //delay(1000);
   
}
