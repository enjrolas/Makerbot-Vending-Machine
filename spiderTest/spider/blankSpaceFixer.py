import os

directories=os.listdir("../Things")
for directory in directories:
    file=open("../Things/"+directory+"/"+directory+".xml",'r')
    text=file.read()
    print directory
    print text
    text=text.replace("\n","")
    text=text.replace("\r","")
    file.close()
    file=open("../Things/"+directory+"/"+directory+".xml",'w')
    file.write(text)
    print text
