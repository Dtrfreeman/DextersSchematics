import LayoutScript
from LayoutScript import *

#remove any text starting with "Generated with the LayoutEditor"

l=project.newLayout(); # open new instance of layout class


SetUp=setup()  # work around as static string variables are not handled correctly

l.open(SetUp.macroDirectory+"/examples/test.gds") # load example design

cl=l.drawing.firstCell # pointer to current cell

while (cl!=None):  # loop over all cells
   c=cl.thisCell
   el=c.firstElement
   while (el!=None):  #loop over all elements
      if (el.thisElement!=None):
          if (el.thisElement.isText()):
               text=el.thisElement.getName()
               if ( text[:31] == "Generated with the LayoutEditor" ):
                     # select this element
                     el.thisElement.selectAll()
          
      el=el.nextElement
   c.deleteSelect()
   cl=cl.nextCell

   

import os
l.drawing.saveFile( os.path.expanduser('~')+"/testout.gds")


print ("Python script completed" )


