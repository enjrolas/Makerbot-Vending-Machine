import processing.core.*; 
import processing.xml.*; 

import controlP5.*; 
import com.apple.cocoa.application.NSApplication; 
import com.apple.cocoa.foundation.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class Makerbot_Vending_Machine extends PApplet {





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

public void setup()
{
  rootDirectory=sketchPath;
  println(rootDirectory);
  mode=DISPLAY_THINGS;
  size(1200, 800);
  font=loadFont("AppleGothic-12.vlw");
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

public void loadThings()
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

public void draw()
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

public void selectThing(int i)
{
  clicked=i;
  selectedThing=(i+thingListOffset)%numThings;
  if(selectedThing<0)
    selectedThing+=numThings;
  println(selectedThing);
  mode=THING_SELECTED;
}

public void UIClick(int i)
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


public int getXPos(int num)  //returns the position of thing number num
{
  return offset+num*(thingSpacing+thingWidth);
}

public void mousePressed()
{
  for (int i=0;i<controlButtons.length;i++)
    if (controlButtons[i].isClicked())
      UIClick(i);
  for (int i=0;i<thingsToDisplay;i++)
    if (thingButtons[i].isClicked())
      selectThing(i);
}

class Button{
  int x,y,buttonWidth, buttonHeight;
  int displayMode;
  Button(int button_x, int button_y, int button_width, int button_height, int display_mode)
  {
    x=button_x;
    y=button_y;
    buttonWidth=button_width;
    buttonHeight=button_height;
    displayMode=display_mode;
  }
  public boolean isClicked()
  {
    if(mode==displayMode)
      return(((mouseX>=x)&&(mouseX<=x+buttonWidth))&&(mouseY>=y)&&(mouseY<y+buttonHeight));
    else
      return false;
  }
  public void display()
  {
  }
}

class UIButton{
  int x,y,buttonWidth, buttonHeight;
  PImage buttonImage;
  int displayMode;
  UIButton(int button_x, int button_y, int button_width, int button_height, String imageString, int display_mode)
  {
    x=button_x;
    y=button_y;
    buttonWidth=button_width;
    buttonHeight=button_height;
    buttonImage=loadImage(imageString);
    displayMode=display_mode;
  }
  public boolean isClicked()
  {
    if(mode==displayMode)
      return(((mouseX>=x)&&(mouseX<=x+buttonWidth))&&(mouseY>=y)&&(mouseY<y+buttonHeight));
    else
      return false;
  }
  public void display()
  {
    if(mode==displayMode)
      image(buttonImage,x,y,buttonWidth, buttonImage.height*buttonWidth/buttonImage.width);
  }
}
class Thing{
  String description;
  String name;
  String author;
  int thingId;
  String stlPath;
  String gcodePath;
  String imagePath;
  String thingDirectory;
  PImage thingImage;
  Thing(String id, XMLElement xml)  //pass the thing the thing ID
  {
    for(int j=0;j<xml.getChildCount();j++)
    {
      String tagName=xml.getChild(j).getName();
      String tagContent=xml.getChild(j).getContent();
      if(tagName.equals("title"))
        name=tagContent;
      if(tagName.equals("author"))
        author=tagContent;
      if(tagName.equals("description"))
        description=tagContent;
    }

    thingId=Integer.parseInt(id);
    thingDirectory=rootDirectory+"/Things/"+id+"/";
//    XMLElement xml=new XMLElement(this, thingDirectory+id+".xml");
    //list contents of directory and 
    File[] files = listFiles(thingDirectory);
    for (int i = 0; i < files.length; i++) 
    {
      String filename=files[i].getName();
      String[] splitFilename=split(filename,".");
      String type=null;
      if(splitFilename.length>1)
        type=splitFilename[1];
      if((type.equals("jpeg"))||(type.equals("jpg"))||(type.equals("bmp")))
        imagePath=thingDirectory+filename;
      if(type.equals("STL"))
        stlPath=thingDirectory+filename;
      if(type.equals("gcode"))
        gcodePath=thingDirectory+filename;
    }
    if(imagePath!=null)
      thingImage=loadImage(imagePath);      
  }
  
  public void display(int x, int y, int displayWidth)
  {
    if(name!=null)
    {
      ArrayList nameStrings=wordWrap(name, displayWidth);
      int lineHeight=(int)(textAscent()+textDescent());
      int topString=(int)(y-nameStrings.size()*lineHeight*1.5f);
      for(int i=0;i<nameStrings.size();i++)
      {
        String nameString=(String) nameStrings.get(i);
        text(nameString,x,topString+i*lineHeight*1.5f);
      }
    }
    if(thingImage!=null)
      image(thingImage,x,y,displayWidth,thingImage.height*displayWidth/thingImage.width);    
  }
  public void displayDescription(int x, int y, int displayWidth)
  {
    textFont(font,14);
    if(description!=null)
    {
      ArrayList nameStrings=wordWrap(description, displayWidth);
      int lineHeight=(int)(textAscent()+textDescent());
      for(int i=0;i<nameStrings.size();i++)
      {
        String nameString=(String) nameStrings.get(i);
        text(nameString,x,(y+i*lineHeight*1.1f));
      }
    }
  }
}

public void build()
{
String applicationRoot=rootDirectory+"/scripts";
String OpenScript=applicationRoot+"/Open.scpt";
String BuildScript=applicationRoot+"/Build.scpt";
String OkScript=applicationRoot+"/Ok.scpt";

  Thing thing=(Thing)things.get(selectedThing);
  String[] okParams={"osascript",OkScript};
  exec(okParams);
  delay(1000);
  
  String[] openParams = {"osascript",OpenScript, thing.gcodePath};  //open the gcode file
  exec(openParams); 
  delay(10000);
 
  String[] buildParams={"osascript",BuildScript};
  exec(buildParams); 
}
// This function returns all the files in a directory as an array of Strings  
public String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
public File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}

// Function to get a list ofall files in a directory and all subdirectories
public ArrayList listFilesRecursive(String dir) {
   ArrayList fileList = new ArrayList(); 
   recurseDir(fileList,dir);
   return fileList;
}

// Recursive function to traverse subdirectories
public void recurseDir(ArrayList a, String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    // If you want to include directories in the list
    a.add(file);  
    File[] subfiles = file.listFiles();
    for (int i = 0; i < subfiles.length; i++) {
      // Call this function on all files in this directory
      recurseDir(a,subfiles[i].getAbsolutePath());
    }
  } else {
    a.add(file);
  }
}

// Function to return an ArrayList of Strings (maybe redo to just make simple array?)
// Arguments: String to be wrapped, maximum width in pixels of each line
public ArrayList wordWrap(String s, int maxWidth) {
  // Make an empty ArrayList
  ArrayList a = new ArrayList();
  float w = 0;    // Accumulate width of chars
  int i = 0;      // Count through chars
  int rememberSpace = 0; // Remember where the last space was
  // As long as we are not at the end of the String
  while (i < s.length()) {
    // Current char
    char c = s.charAt(i);
    w += textWidth(c); // accumulate width
    if (c == ' ') rememberSpace = i; // Are we a blank space?
    if (w > maxWidth) {  // Have we reached the end of a line?
      String sub = s.substring(0,rememberSpace); // Make a substring
      // Chop off space at beginning
      if (sub.length() > 0 && sub.charAt(0) == ' ') sub = sub.substring(1,sub.length());
      // Add substring to the list
      a.add(sub);
      // Reset everything
      s = s.substring(rememberSpace,s.length());
      i = 0;
      w = 0;
    } 
    else {
      i++;  // Keep going!
    }
  }
 
  // Take care of the last remaining line
  if (s.length() > 0 && s.charAt(0) == ' ') s = s.substring(1,s.length());
  a.add(s);
 
  return a;
}
  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "Makerbot_Vending_Machine" });
  }
}
