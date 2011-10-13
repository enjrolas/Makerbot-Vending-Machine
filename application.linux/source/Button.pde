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
  boolean isClicked()
  {
    if(mode==displayMode)
      return(((mouseX>=x)&&(mouseX<=x+buttonWidth))&&(mouseY>=y)&&(mouseY<y+buttonHeight));
    else
      return false;
  }
  void display()
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
  boolean isClicked()
  {
    if(mode==displayMode)
      return(((mouseX>=x)&&(mouseX<=x+buttonWidth))&&(mouseY>=y)&&(mouseY<y+buttonHeight));
    else
      return false;
  }
  void display()
  {
    if(mode==displayMode)
      image(buttonImage,x,y,buttonWidth, buttonImage.height*buttonWidth/buttonImage.width);
  }
}
