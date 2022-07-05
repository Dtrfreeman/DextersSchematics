
import LayoutScript
from LayoutScript import *

import random,sys

l=project.newLayout();

c=l.drawing.currentCell
c.cellName="randomCircleArray"


sizeX=10000 #array width
sizeY=10000 #array height
diameter=100 #circle diameter
count=2000 #number circles
layer =11  #layer for circles
space=50 #minimum circle to circle distance

ds=diameter+space;

for i in range (0,count):
    try_=0
    found=False
    while (found== False):
        try_+=1
        x=random.randint(0,sizeX)
        y=random.randint(0,sizeY)
        p=point(x,y);
        e=c.nearestElement(p)
        if (e==None):
                 found=True
        else:
           p2=point()
           radius=pointerInt()
           # set value with
           # radius.assign(45);
           # read with
           # print (radius.value())
           if e.thisElement.isCircle(p2,radius):
                  if (p2.x()>x+ds):
                          found=True
                  elif (p2.x()<x-ds):
                          found=True
                  elif (p2.y()<y-ds):
                           found=True
                  elif (p2.y()>y+ds):
                           found=True
  
    if (try_>1000):
                   sys.exit()
    c.addCircle(layer,p,diameter/2)        
             

# save result in your home folder
import os
l.drawing.saveFile( os.path.expanduser('~')+"/testout.gds")
#l.drawing.saveFile("/Users/apple/testout.gds")



print ("circle array completed" )