import processing.serial.*;
import controlP5.*;

Serial myPort;  // The serial port

ControlP5 controlP5;
VendingMachine vendingMachine;
int position;

void setup()
{
  myPort=new Serial(this, Serial.list()[0], 115200);
  vendingMachine=new VendingMachine();
  controlP5 = new ControlP5(this);
    for (int i=1;i<7;i++)  
      controlP5.addButton("bin"+i, 0, 150, 5+i*20, 100, 20);
  controlP5.addButton("STOP!", 0, 400, 100, 100, 100);
  size(600,600);
}

void draw()
{
  background(0);
  position=vendingMachine.getPosition();
  stroke(255);
  fill(255);
  text("position:  "+position,50,20);
}

public void controlEvent(ControlEvent theEvent) {
  println(theEvent.controller().name());
  for (int i=1;i<7;i++)
    if (theEvent.controller().name().equals("bin"+i))
    {
      println("moving to bin "+i+"...");
      vendingMachine.moveToPosition(i);
    }
    if (theEvent.controller().name().equals("STOP!"))
      vendingMachine.stop();    
}
