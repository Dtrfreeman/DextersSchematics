import LayoutScript
from LayoutScript import *

#outputs all polygons on layer 23

l=project.newLayout(); # open new instance of layout class


SetUp=setup()  # work around as static string variables are not handled correctly

l.open(SetUp.macroDirectory+"/examples/test.gds") # load example design

cl=l.drawing.firstCell # pointer to current cell

while (cl!=None):  # loop over all cells
   c=cl.thisCell
   el=c.firstElement
   #print("process cell :"+c.cellName)
   while (el!=None):  #loop over all elements
      if (el.thisElement!=None):
          if (el.thisElement.isPolygon() and (el.thisElement.layerNum==23)):
               # polygon on layer 23
               pa=el.thisElement.getPoints();
               print("Polygon ("+str(pa.size())+"): ");
               for i in range (0,pa.size()): # output all coordinates
                     x=pa.point(i).x()
                     y=pa.point(i).y()
                     print("("+str(x)+", "+str(y)+")")
               
      el=el.nextElement
   cl=cl.nextCell

   

import os
l.drawing.saveFile( os.path.expanduser('~')+"/testout.gds")


print ("Python script completed" )


