class VendingMachine()
{
  final int UNLOCK=10;
  final int LOCK=11;
  final int DOOR_STATE_REQUEST=22;
  final int DOOR_OPEN=23;
  final int DOOR_CLOSED=24;
  final int POSITION_REQUEST=25;
  final int HEARTBEAT_REQUEST=26;
  final int HEARTBEAT_RESPONSE=27;
  int position;
  VendingMachine()
  {
    position=1;
    moveToPosition(position);
    lockDoor();
    
  }
  void moveToPosition(int a)
  {
    position=a;
    myPort.write(position);    
  }
  void unlockDoor()
  {
    myPort.write(UNLOCK);
  }
  void lockDoor()
  {
    myPort.write(LOCK);
  }
  boolean getDoorState()
  {
    myPort.write(DOOR_STATE_REQUEST);
    int response=getResponse(50);
    if(response==24)
      return False;
    else
      return True;
  }
  int getPosition()
  {
   myPort.write(POSITION_REQUEST);
   return getResponse(50); 
  }
  boolean heartbeat()
  {
    myPort.clear();
    myPort.write(HEARTBEAT_REQUEST);
    int response=getResponse(50);
    if(response==HEARTBEAT_RESPONSE)
      return True;
    else
      return False;
  }
  
  int getResponse(int timeout)
  {
    int response=-1;
    time=millis();
    while((myPort.available()==0)&&(millis()-startTime<timeout)){}
    if(myPort.available()>0)
      response=myPort.read();
    return response;
  }
}
