import processing.serial.*;
import controlP5.*;

Serial myPort;  // The serial port

int offset=80;
int thingSpacing=10;
int thingWidth=200;
int thingsToDisplay;
int selectedWidth=400;

int buttonMargin=20;
int buttonSize=50;

int mode;

final int DISPLAY_THINGS=0;
final int THING_SELECTED=1;

final int LEFT=0;
final int RIGHT=1;
final int BACK=2;
final int BUILD=3;
final int SELECTED_LEFT=4;
final int SELECTED_RIGHT=5;

int selectedThing;

int clicked=0;
int thingListOffset=0;
LinkedList things;
Button[] thingButtons;
UIButton[] controlButtons;

int numThings;

String rootDirectory;
PFont font;

VendingMachine vendingMachine;

void setup()
{
  rootDirectory=sketchPath;
  vendingMachine=new vendingMachine();
  myPort = new Serial(this, Serial.list()[0], 115200);
  println(rootDirectory);
  mode=DISPLAY_THINGS;
  size(1200, 800);
  font=loadFont("Baskerville-12.vlw");
//  font=loadFont("AppleGothic-12.vlw");
  textFont(font, 12);
  loadThings();
  numThings=things.size();
  thingsToDisplay=(width-offset*2)/(thingWidth+thingSpacing);
  if (thingsToDisplay<things.size())
    thingsToDisplay=things.size();
  imageMode(CORNER);
  thingButtons=new Button[thingsToDisplay];
  controlButtons=new UIButton[6];
  controlButtons[LEFT]=new UIButton(buttonMargin, 300, buttonSize, buttonSize, rootDirectory+"/UI/left.jpg",DISPLAY_THINGS);
  controlButtons[RIGHT]=new UIButton(width-buttonSize-buttonMargin, 300, buttonSize, buttonSize, rootDirectory+"/UI/right.jpg",DISPLAY_THINGS);
  controlButtons[BACK]=new UIButton(100, 700, 100, 100, rootDirectory+"/UI/back.jpg",THING_SELECTED);
  controlButtons[BUILD]=new UIButton(1000, 300, 150, 150, rootDirectory+"/UI/build.jpg",THING_SELECTED);
  controlButtons[SELECTED_LEFT]=new UIButton(buttonMargin, 50, buttonSize, buttonSize, rootDirectory+"/UI/left.jpg",THING_SELECTED);
  controlButtons[SELECTED_RIGHT]=new UIButton(width-buttonSize-buttonMargin, 50, buttonSize, buttonSize, rootDirectory+"/UI/right.jpg",THING_SELECTED);

  for (int i=0;i<thingsToDisplay;i++)
    thingButtons[i]=new Button(getXPos(i), 150, thingWidth, 400, DISPLAY_THINGS);
}

void loadThings()
{
  things=new LinkedList();
  File[] files = listFiles(sketchPath+"/Things/");
  for (int i = 0; i < files.length; i++) {
    File f = files[i];    
    if (f.isDirectory())
    {
      String id=f.getName();
      String thingDirectory=rootDirectory+"/Things/"+id+"/";
      String xmlFile=thingDirectory+id+".xml"; 
      XMLElement xml=new XMLElement(this, xmlFile);
      println(id);
      things.add(new Thing(id, xml));
    }
  }
}

void draw()
{
  background(0);
    for (int i=0;i<controlButtons.length;i++)  
      controlButtons[i].display();

  if (mode==DISPLAY_THINGS) {
    for (int i=0;i<thingsToDisplay;i++)
    {
      int thingOffset= (thingListOffset+i)%numThings;
      if(thingOffset<0)
        thingOffset+=numThings;
      Thing thing=(Thing)things.get(thingOffset);
      int xPos=getXPos(i);
      stroke(255);
      thing.display(xPos, 200, thingWidth);
      noFill();
      if (i==clicked)
        stroke(0, 255, 0);
      else
        stroke(0, 0, 255);
      thingButtons[i].display();
    }
  }
  if(mode==THING_SELECTED)
  {
    Thing thing=(Thing)things.get(selectedThing);
    thing.display(100,100,selectedWidth);    
    thing.displayDescription(600,100,400);
  }
}

void selectThing(int i)
{
  clicked=i;
  selectedThing=(i+thingListOffset)%numThings;
  if(selectedThing<0)
    selectedThing+=numThings;
  println(selectedThing);
  mode=THING_SELECTED;
}

void UIClick(int i)
{
  switch(i){
  case(RIGHT):
    thingListOffset--;
    break;
  case(LEFT):
    thingListOffset++;  
    break;
  case(BACK):
    mode=DISPLAY_THINGS;
    break;
  case(BUILD):
    build();
    break;
  case(SELECTED_RIGHT):
    selectedThing++;
    if(selectedThing>=numThings)
      selectedThing-=numThings;
    break;
  case(SELECTED_LEFT):
    selectedThing--;
    if(selectedThing<0)
      selectedThing=numThings-1;
    break;
  }
}


int getXPos(int num)  //returns the position of thing number num
{
  return offset+num*(thingSpacing+thingWidth);
}

void mousePressed()
{
  for (int i=0;i<controlButtons.length;i++)
    if (controlButtons[i].isClicked())
      UIClick(i);
  for (int i=0;i<thingsToDisplay;i++)
    if (thingButtons[i].isClicked())
      selectThing(i);
}

