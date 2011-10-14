import urllib
import re
from BeautifulSoup import BeautifulSoup, SoupStrainer, NavigableString

def grabThing(thingId):
    opener=urllib.FancyURLopener({})
    url="http://www.thingiverse.com/thing:"+str(thingId)
    f=opener.open(url)
    page=f.read()
    soup=BeautifulSoup(page)

    outputFile=open("Things/"+str(thingId)+"/"+str(thingId)+".xml",'w')
    
    print page
#title and author
    parts=soup.findAll('h1')
    title=parts[1].contents[0].string
    print title
    title=title.replace("by","")
    title=title.strip()
    author=parts[1].a.contents[0].string
    outputFile.write("<thing>")
    outputFile.write("<id>"+str(thingId)+"</id>")
    print "<title>"+title+"</title>"
    outputFile.write("<title>"+title+"</title>")
    print "<author>"+author+"</author>"
    outputFile.write("<author>"+author+"</author>")

#description
    parts=soup.findAll('h2')
    descriptionTags=parts[1].nextSibling.nextSibling.contents
    description=""
    for tag in descriptionTags:
        text=tag.string
        if text!=None:
            text=text.replace('\t','')
            description+=text
    descriptionTag="<description>"+description+"</description>"
    descriptionTag=descriptionTag.encode('ascii','ignore')
    print descriptionTag
    outputFile.write(descriptionTag)
    
    outputFile.write("</thing>")


grabThing(11816)
