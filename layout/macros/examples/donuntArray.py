import LayoutScript
from LayoutScript import *

# creates an array of donut with different parameter


l=project.newLayout(); 

dr=l.drawing # pointer to the main drawing

dr.currentCell.cellName="python_example_donuts"

nx=5;
ny=5;
sizeStart=200;
sizeStep=100;
stepX=4000;
stepY=3900;
radiusouter=1000;
radiusinner=500;
radiusStep=50;
  
for x in range (0,nx):
        for y in range (0,ny):
                dr.activeLayer=10
                dr.point(x*stepX,y*stepY)
                dr.point(x*stepX,y*stepY+radiusouter+radiusStep*y)
                dr.point(x*stepX,y*stepY+radiusouter+radiusStep*y)
                dr.spiral()
                dr.currentCell.firstElement.thisElement.selectAll()
                dr.point(x*stepX,y*stepY)
                dr.point(x*stepX,y*stepY+radiusinner+radiusStep*x)
                dr.point(x*stepX,y*stepY+radiusinner+radiusStep*x)
                dr.spiral()
                dr.currentCell.firstElement.thisElement.selectAll()
                dr.point(x*stepX,y*stepY+radiusinner+radiusStep*x)
                dr.point(x*stepX,y*stepY+radiusouter+radiusStep*y)
                dr.path()
                dr.currentCell.firstElement.thisElement.selectAll()
                dr.mergeSelect()
                dr.closeToPolygon()
                dr.deselectAll()


# writes result to the home folder

import os
l.drawing.saveFile( os.path.expanduser('~')+"/testout.gds")


print ("Python script completed" )


