import LayoutScript
from LayoutScript import *

#sets the size of text with negative width to -10
# and round paths to a grid of 1000

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
          if (el.thisElement.isPath()):
               # select this element
               el.thisElement.selectAll()
          if ((el.thisElement.getWidth()<0) and (el.thisElement.isText())):
               el.thisElement.setWidth(-10)
      el=el.nextElement
   c.roundSelect(1000)  # do a round of all selcted element in the cell
   c.deselectAll()
   cl=cl.nextCell

   

import os
l.drawing.saveFile( os.path.expanduser('~')+"/testout.gds")


print ("Python script completed" )


