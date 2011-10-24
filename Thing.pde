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
/*   uses up wayyyy too much memory to have all the images loaded */
//    if(imagePath!=null)
//      thingImage=loadImage(imagePath);      
  }
  
  void display(int x, int y, int displayWidth)
  {
    if(thingImage==null)
    {
      thingImage=loadImage(imagePath);
    }
    if(name!=null)
    {
      ArrayList nameStrings=wordWrap(name, displayWidth);
      int lineHeight=(int)(textAscent()+textDescent());
      int topString=(int)(y-nameStrings.size()*lineHeight*1.5);
      for(int i=0;i<nameStrings.size();i++)
      {
        String nameString=(String) nameStrings.get(i);
        text(nameString,x,topString+i*lineHeight*1.5);
      }
    }
    if(thingImage!=null)
      image(thingImage,x,y,displayWidth,thingImage.height*displayWidth/thingImage.width);    
  }
  //free up some memory
  void free()
  {
    thingImage=null;
  }
  
  void displayDescription(int x, int y, int displayWidth)
  {
    textFont(font,14);
    if(description!=null)
    {
      ArrayList nameStrings=wordWrap(description, displayWidth);
      int lineHeight=(int)(textAscent()+textDescent());
      for(int i=0;i<nameStrings.size();i++)
      {
        String nameString=(String) nameStrings.get(i);
        text(nameString,x,(y+i*lineHeight*1.1));
      }
    }
  }
}
