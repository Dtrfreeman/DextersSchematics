import LayoutScript
from LayoutScript import *

# automatic labeling of an array

   
l=project.newLayout(); 

dr=l.drawing # pointer to the main drawing

dr.currentCell.cellName="python_example_label"

dr.clearPoints()



for x in range (0,10):
        for y in range (0,10):
                dr.point(x*1800,y*800)
                dr.text("#"+str(x)+"/"+str(y))
        


dr.selectAll()
dr.setWidth(400)
dr.toPolygon()
dr.deselectAll();

# writes result to the home folder

import os
l.drawing.saveFile( os.path.expanduser('~')+"/testout.gds")


print ("Python script completed" )


