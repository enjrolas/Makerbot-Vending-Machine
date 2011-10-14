
#define sense1 8 //reflectance sensor pin mappings--used for reading carousel position
#define sense2 9 
#define sense3 10 

#define UNLOCK 10
#define LOCK 11
#define DOOR_STATE_REQUEST 22
#define DOOR_OPEN 23
#define DOOR_CLOSED 24
#define POSITION_REQUEST 25
#define HEARTBEAT_REQUEST 26
#define HEARTBEAT_RESPONSE 27
#define STOP 28

//#define DEBUG 1 //comment out for less chatter on the serial port

#define DIRECTION 2
#define SPEED 3

#define CW 0
#define CCW 1

#define IN_POSITION 0
#define MOVING_TO_BIN 1 
#define CENTERING_BIN 2
#define DOOR_OPEN 3
#define STOPPED 4

unsigned char dir;
unsigned char mode;
long sense1Reflectance, sense2Reflectance, sense3Reflectance;
unsigned char positionValue;
unsigned char target;
long threshhold=2000;

void setup(){
  mode=IN_POSITION;
  pinMode(DIRECTION,OUTPUT);
  pinMode(SPEED,OUTPUT);
  digitalWrite(SPEED, LOW);
  Serial.begin(115200);
}

void loop(){
  if(Serial.available()>0)
  {
    char command=Serial.read();
    if((command>0)&&(command<7))  //move command
    {
      target=command;
      unsigned char compPos;
      if(positionValue<target)
        compPos=positionValue+6;
      else
        compPos=positionValue;
      if(compPos<target+2)
        dir=CCW;
      else
        dir=CW;
      mode=MOVING_TO_BIN;
    }
   if(command==UNLOCK)
    unlockDoor();
   if(command==LOCK)
    lockDoor();
   if(command==POSITION_REQUEST)
     Serial.write(positionValue); 
   if(command==STOP)
   {
     mode=STOPPED;
     analogWrite(SPEED,0);
   }
  }
  
  readPosition();
  if(mode==MOVING_TO_BIN)
  {
    #ifdef DEBUG
      Serial.print("Moving to bin.  Position:  ");
      Serial.print(positionValue,DEC);
      Serial.print("  Target:  ");
      Serial.println(target,DEC);
    #endif
    if(positionValue!=target)
    {
      digitalWrite(DIRECTION, dir);
      digitalWrite(SPEED,HIGH);
    }
    else
      mode=CENTERING_BIN;
  }
  if(mode==CENTERING_BIN)
  {
    #ifdef DEBUG
      Serial.println("centering bin");
    #endif
    if(positionValue==0)
    {
      digitalWrite(SPEED,LOW);  //stop the carousel
      mode=IN_POSITION;
    }
  }
  if(mode==IN_POSITION)
  {
    #ifdef DEBUG
      Serial.print("in position ");
      Serial.println(positionValue, DEC);
    #endif
  }
}

void unlockDoor()
{
}

void lockDoor()
{
}

void readPosition(){
  long time, diff;
  positionValue=0;
  //Returns value from the QRE1113 
  //Lower numbers mean more refleacive
  //More than 3000 means nothing was reflected.
  pinMode( sense1, OUTPUT );
  digitalWrite( sense1, HIGH );
  delayMicroseconds(10);
  pinMode( sense1, INPUT );

  time = micros();

  //time how long the input is HIGH, but quit after 3ms as nothing happens after that
  while (digitalRead(sense1) == HIGH && micros() - time < 3000);
  diff = micros() - time;
  sense1Reflectance=diff;

  if(sense1Reflectance<threshhold)
    positionValue+=1;
    
  pinMode( sense2, OUTPUT );
  digitalWrite( sense2, HIGH );
  delayMicroseconds(10);
  pinMode( sense2, INPUT );

  time = micros();

  //time how long the input is HIGH, but quit after 3ms as nothing happens after that
  while (digitalRead(sense2) == HIGH && micros() - time < 3000);
  diff = micros() - time;
  sense2Reflectance=diff;
  if(sense2Reflectance<threshhold)
    positionValue+=2;

  pinMode( sense3, OUTPUT );
  digitalWrite( sense3, HIGH );
  delayMicroseconds(10);
  pinMode( sense3, INPUT );

  time = micros();

  //time how long the input is HIGH, but quit after 3ms as nothing happens after that
  while (digitalRead(sense3) == HIGH && micros() - time < 3000);
  diff = micros() - time;
  sense3Reflectance=diff;

  if(sense3Reflectance<threshhold)
    positionValue+=4;

}
