import urllib
import urllib2
import re
from BeautifulSoup import BeautifulSoup, SoupStrainer, NavigableString
import os, errno
from urlparse import urlparse


def ensure_dir(dir):
    if not os.path.exists(dir):
        os.makedirs(dir)

def download(URL, filename):
    u = urllib2.urlopen(URL)
    f = open(filename, 'wb')
    meta = u.info()
    file_size = int(meta.getheaders("Content-Length")[0])
    print "Downloading: %s Bytes: %s" % (filename, file_size)
    
    file_size_dl = 0
    block_sz = 8192
    while True:
        buffer = u.read(block_sz)
        if not buffer:
            break
        
        file_size_dl += len(buffer)
        f.write(buffer)
        status = r"%10d  [%3.2f%%]" % (file_size_dl, file_size_dl * 100. / file_size)
        status = status + chr(8)*(len(status)+1)
        print status,

    f.close()


def grabThing(thingId):
    opener=urllib.FancyURLopener({})
    url="http://www.thingiverse.com/thing:"+str(thingId)
    f=opener.open(url)
#    f=open("11816.html",'r')
    page=f.read()
    soup=BeautifulSoup(page)
    hasStlFiles=False

    
#title and author
    titleTag=soup.find('title')
    if titleTag!=None:
        title=titleTag.contents[0].string.split(" ")[0]
        title=title.encode('ascii','ignore').strip()
        if title != "Error":  #the thing exists
            directoryPath="../Things/"+str(thingId)
            author=""
            print title
            parts=soup.findAll('h1')
            if len(parts)>1:
                titleString=titleTag.contents[0].string
                titleParts=titleString.split(" ")
                title=""
                for titlePart in titleParts:
                    if titlePart=="by":
                        break
                    else:
                        title+=titlePart+" "

                print title
                title=title.strip()
                link=parts[1].a;
                if link!=None:

#stl files
                    parts=soup.findAll('h3', 'file_info')            
                    print parts
                    for part in parts:
                        filename=part.contents[0].strip()
                        if filename.find(".stl")!=-1:
                            ensure_dir(directoryPath)
                            print directoryPath+"/"+filename
                            hasStlFiles=True
                            downloadURL=part.parent.parent.a['href']
                            downloadURL="http://www.thingiverse.com"+downloadURL
                            print filename+" "+downloadURL
                            urllib.urlretrieve(downloadURL, directoryPath+"/"+filename)
                    #                    download(downloadURL, directoryPath+"/"+filename)
                            author=link.contents[0].string
                    

#description
                    parts=soup.findAll('h2')
                    if len(parts)>1:
                        descriptionTags=parts[1].nextSibling.nextSibling.contents
                        description=""
                        for tag in descriptionTags:
                            text=tag.string
                            if text!=None:
                                text=text.replace('\t','')
                                text=text.strip()
                                description+=text
                        descriptionTag="<description>"+description+"</description>"
                        descriptionTag=descriptionTag.encode('ascii','ignore')
                        print descriptionTag
                        
            if hasStlFiles:
#create directory if it does not exist, and open xml file
                outputFile=open(directoryPath+"/"+str(thingId)+".xml",'w')

#download images
                gallery=soup.findAll(rel="gallery[thing]")
                if len(gallery)>0:
                    pictureIndex=0
                    for picture in gallery:
                        imageURL=picture["href"]
                        type=imageURL.split(".")[-1]
                        filename=str(pictureIndex)+"."+type
                        urllib.urlretrieve(imageURL, directoryPath+"/"+filename)
                        pictureIndex+=1


                outputFile.write("<thing>")
                outputFile.write("<id>"+str(thingId)+"</id>")
                print "<title>"+title+"</title>"
                outputFile.write("<title>"+title+"</title>")
                print "<author>"+author+"</author>"
                outputFile.write("<author>"+author+"</author>")
                outputFile.write(descriptionTag)
                outputFile.write("</thing>")



    


for i in range(366,1000):
    print "Trying..."+str(i)
    grabThing(i)


#grabThing(157)
