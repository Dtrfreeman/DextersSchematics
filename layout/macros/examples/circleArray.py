import LayoutScript
from LayoutScript import *

# creates an array of circles with different parameter


l=project.newLayout(); 

dr=l.drawing # pointer to the main drawing

nx=10
ny=9
sizeStart=1000
sizeStep=50
stepX=4000
stepY=3900
  
for x in range (0,nx):
        for y in range (0,ny):
                radius=x*sizeStep+sizeStart
                dr.activeLayer=y
                dr.p(x*stepX,y*stepY)
                dr.p(x*stepX,y*stepY+radius)
                dr.circle()

# writes result to the home folder

import os
l.drawing.saveFile( os.path.expanduser('~')+"/testout.gds")


print ("Python script completed" )


